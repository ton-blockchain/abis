/// Blum Memepad Jetton minter: bonding-curve launchpad token that lists on STON.fi once the curve threshold is reached.
contract BlumMemepadMinter {
    author: "Blum"
    version: "2.0"
    description: "Blum Memepad Minter sells its Jetton for GRAM along a bonding curve, buys it back on sell notifications, and deposits the collected liquidity into STON.fi when the threshold supply is sold."
    storage: BlumMemepadMinterStorage
    incomingMessages: BlumMemepadMinterIncomingMessage
    outgoingMessages: BlumMemepadMinterOutgoingMessage
    emittedEvents: BlumMemepadMinterEvent
}

/// STON.fi addresses used for the liquidity deposit.
struct BlumMemepadMinterAddresses {
    /// STON.fi router.
    routerAddress: address
    /// Router pTON wallet that receives the GRAM leg.
    routerPtonWalletAddress: address
}

/// Curve counters referenced from the root storage.
struct BlumMemepadMinterParams {
    /// GRAM the curve collects before listing.
    curveTon: coins
    /// Unix time of the last buy or sell.
    lastTradeDate: uint32
    /// GRAM collected for liquidity so far.
    tonLiqCollected: coins
}

/// Deployment configuration referenced from the root storage.
struct BlumMemepadMinterConfig {
    /// Factory that deployed the minter.
    factory: address
    /// Token author.
    author: address
    /// Whether an agent is attached.
    hasAgent: bool
    /// Recipient of trade and liquidity fees.
    feeRecipient: address
    /// Buy fee in basis points.
    buyFeeBasis: uint16
    /// Sell fee in basis points.
    sellFeeBasis: uint16
    /// Fee paid when liquidity is deposited.
    liquidityFee: coins
    /// Payload copied into the liquidity fee payout.
    customPayload: cell?
    /// STON.fi addresses.
    addresses: Cell<BlumMemepadMinterAddresses>
}

/// Persistent minter state.
struct BlumMemepadMinterStorage {
    /// Total minted supply.
    totalSupply: coins
    /// Curve phase: 0 trading, 1 listed.
    phase: uint2
    /// Jetton content cell.
    content: cell
    /// Jetton wallet code.
    walletCode: cell
    /// Curve counters.
    params: Cell<BlumMemepadMinterParams>
    /// Deployment configuration.
    config: Cell<BlumMemepadMinterConfig>
}

/// GRAM purchase along the curve.
struct (0xaf750d34) BlumMemepadMinterBuy {
    /// Query id copied into the mint and the fee payout.
    queryId: uint64
    /// Minimum Jetton amount the buyer accepts.
    minReceiveAmount: coins
    /// Recipient of the tokens; empty means the sender.
    destination: address?
    /// Optional payload copied into the fee payout and the log.
    customPayload: cell?
}

/// Sell request forwarded by a memepad wallet.
struct (0xb7e76bfd) BlumMemepadMinterSellNotification {
    /// Query id copied into the payout and the fee payout.
    queryId: uint64
    /// Jetton amount sold.
    amount: coins
    /// Minimum GRAM the seller accepts.
    minTonAmount: coins
    /// Wallet owner receiving the GRAM.
    ownerAddress: address
    /// Optional payload copied into the fee payout and the log.
    customPayload: cell?
}

/// Unlock request forwarded by a memepad wallet once the token is listed.
struct (0x06ae173e) BlumMemepadMinterUnlockRequest {
    /// Query id copied into the approval.
    queryId: uint64
    /// Wallet owner asking to unlock transfers.
    ownerAddress: address
}

/// Standard burn notification from a memepad wallet.
struct (0x7bdd97de) BlumMemepadMinterBurnNotification {
    /// Query id copied into the excess reply.
    queryId: uint64
    /// Burned Jetton amount.
    amount: coins
    /// Wallet owner.
    ownerAddress: address
    /// Address that receives the excess GRAM.
    responseDestination: address?
    /// Optional payload copied from the burn.
    customPayload: cell?
}

/// Transfer notification from the minter's own Jetton wallet; the tokens are burned.
struct (0x7362d09c) BlumMemepadMinterTransferNotification {
    /// Query id copied into the burn transfer.
    queryId: uint64
    /// Received Jetton amount.
    amount: coins
    /// Sender of the tokens.
    senderAddress: address?
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// TEP-89 wallet address discovery request.
struct (0x2c76b973) BlumMemepadMinterProvideWalletAddress {
    /// Query id copied into the reply.
    queryId: uint64
    /// Owner whose wallet address is requested.
    ownerAddress: address
    /// Whether the reply repeats the owner address.
    includeAddress: bool
}

/// Excess return accepted without processing.
struct (0xd53276db) BlumMemepadMinterExcesses {
    /// Query id of the excess.
    queryId: uint64
}

/// Internal message bodies accepted by the minter.
type BlumMemepadMinterIncomingMessage =
    | BlumMemepadMinterBuy
    | BlumMemepadMinterSellNotification
    | BlumMemepadMinterUnlockRequest
    | BlumMemepadMinterBurnNotification
    | BlumMemepadMinterTransferNotification
    | BlumMemepadMinterProvideWalletAddress
    | BlumMemepadMinterExcesses

/// Mint sent to the buyer's wallet.
struct (0x178d4519) BlumMemepadMinterInternalTransfer {
    /// Query id copied from the buy.
    queryId: uint64
    /// Minted Jetton amount.
    amount: coins
    /// Always empty for mints.
    fromAddress: address?
    /// Address that receives the excess GRAM.
    responseAddress: address?
    /// GRAM forwarded to the owner.
    forwardTonAmount: coins
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Trade fee sent to the fee recipient.
struct (0xfdaa7c9d) BlumMemepadMinterFeePayout {
    /// Query id copied from the trade.
    queryId: uint64
    /// Payload copied from the trade.
    customPayload: cell?
}

/// Liquidity fee sent to the fee recipient when the token is listed.
struct (0x94534c67) BlumMemepadMinterLiquidityFeePayout {
    /// Query id copied from the closing buy.
    queryId: uint64
    /// Payload copied from the deployment configuration.
    customPayload: cell?
}

/// GRAM returned to the seller.
struct (0xaf5ececd) BlumMemepadMinterSellPayout {
    /// Query id copied from the sell.
    queryId: uint64
}

/// Unlock approval sent back to the requesting wallet.
struct (0xb964422d) BlumMemepadMinterUnlockApprove {
    /// Query id copied from the request.
    queryId: uint64
}

/// Refund sent to the buyer when a purchase fails.
struct (0x04924323) BlumMemepadMinterFailed {
    /// Query id copied from the buy.
    queryId: uint64
    /// Exit code of the failed purchase.
    errorCode: uint32
}

/// TEP-89 wallet address discovery reply.
struct (0xd1735400) BlumMemepadMinterTakeWalletAddress {
    /// Query id copied from the request.
    queryId: uint64
    /// Wallet address of the requested owner.
    walletAddress: address
    /// Owner address repeated on request.
    ownerAddress: cell?
}

/// Burn of tokens received by transfer notification, sent to the minter's own wallet.
struct (0x0f8a7ea5) BlumMemepadMinterTransfer {
    /// Query id copied from the notification.
    queryId: uint64
    /// Jetton amount to move.
    amount: coins
    /// Burner address.
    destination: address
    /// Address that receives the excess GRAM.
    responseDestination: address?
    /// Always empty.
    customPayload: cell?
    /// Always zero.
    forwardTonAmount: coins
    /// Always empty.
    forwardPayload: RemainingBitsAndRefs
}

/// Internal message bodies emitted by the minter.
type BlumMemepadMinterOutgoingMessage =
    | BlumMemepadMinterInternalTransfer
    | BlumMemepadMinterFeePayout
    | BlumMemepadMinterLiquidityFeePayout
    | BlumMemepadMinterSellPayout
    | BlumMemepadMinterUnlockApprove
    | BlumMemepadMinterFailed
    | BlumMemepadMinterTakeWalletAddress
    | BlumMemepadMinterTransfer
    | BlumMemepadMinterExcesses

/// External log emitted after a buy.
struct (0xceac8af4) BlumMemepadMinterBuyLog {
    /// Buyer that received the tokens.
    buyerAddress: address
    /// GRAM consumed by the purchase.
    tonAmount: coins
    /// Jetton amount minted.
    jettonAmount: coins
    /// Total supply after the buy.
    newSupply: coins
    /// GRAM collected for liquidity after the buy.
    tonLiqCollected: coins
    /// Payload copied from the buy.
    customPayload: cell?
}

/// External log emitted after a sell.
struct (0xef2e2def) BlumMemepadMinterSellLog {
    /// Seller that received the GRAM.
    sellerAddress: address
    /// GRAM returned to the seller.
    tonAmount: coins
    /// Jetton amount burned.
    jettonAmount: coins
    /// Total supply after the sell.
    newSupply: coins
    /// GRAM collected for liquidity after the sell.
    tonLiqCollected: coins
    /// Payload copied from the sell.
    customPayload: cell?
}

/// External log emitted when the collected liquidity is sent to STON.fi.
struct (0x30c7219b) BlumMemepadMinterSendLiquidityLog {
    /// GRAM leg of the liquidity.
    tonAmount: coins
    /// Jetton leg of the liquidity.
    jettonAmount: coins
}

/// External event bodies emitted by the minter.
type BlumMemepadMinterEvent =
    | BlumMemepadMinterBuyLog
    | BlumMemepadMinterSellLog
    | BlumMemepadMinterSendLiquidityLog

/// Standard Jetton master data.
struct BlumMemepadMinterJettonData {
    /// Total minted supply.
    totalSupply: int
    /// Always false.
    mintable: bool
    /// Always empty.
    adminAddress: any_address
    /// Jetton content cell.
    jettonContent: cell
    /// Jetton wallet code.
    jettonWalletCode: cell
}

/// Fee and amount pair returned by the curve quotes.
struct BlumMemepadMinterQuote {
    /// Fee charged in nanograms.
    fees: int
    /// Quoted amount.
    amount: int
}

/// Full launchpad state returned by `get_bcl_data`.
struct BlumMemepadMinterBclData {
    /// DEX the liquidity is deposited to.
    dexType: int
    /// Total minted supply.
    totalSupply: int
    /// Supply sold along the curve before listing.
    thresholdSupply: int
    /// Supply minted for the liquidity pool.
    liqSupply: int
    /// Factory that deployed the minter.
    factory: address
    /// Token author.
    author: address
    /// Jetton content cell.
    content: cell
    /// Recipient of fees.
    feeRecipient: address
    /// Buy fee in basis points.
    buyFeeBasis: int
    /// Sell fee in basis points.
    sellFeeBasis: int
    /// Unix time of the last trade.
    lastTradeDate: int
    /// Curve phase.
    phase: int
    /// GRAM collected for liquidity.
    tonLiqCollected: int
    /// Fee paid when liquidity is deposited.
    liquidityFee: int
    /// GRAM needed to buy the rest of the curve.
    fullPriceTonNeed: int
    /// Fees charged when buying the rest of the curve.
    fullPriceTonFees: int
    /// STON.fi router.
    routerAddress: address
    /// Router pTON wallet.
    routerPtonWalletAddress: address
}

/// Return the standard Jetton master data.
get fun get_jetton_data(): BlumMemepadMinterJettonData {
    throw 0;
}

/// Return the wallet address for the given owner.
get fun get_wallet_address(ownerAddress: address): address {
    throw 0;
}

/// Return the current price of one Jetton unit along the curve.
get fun coin_price(): int {
    throw 0;
}

/// Quote the Jetton amount received for the given nanograms.
get fun coins_for_tons(tons: int): BlumMemepadMinterQuote {
    throw 0;
}

/// Quote the nanograms received for the given Jetton amount.
get fun tons_for_coins(coins: int): BlumMemepadMinterQuote {
    throw 0;
}

/// Return the full launchpad state.
get fun get_bcl_data(): BlumMemepadMinterBclData {
    throw 0;
}
