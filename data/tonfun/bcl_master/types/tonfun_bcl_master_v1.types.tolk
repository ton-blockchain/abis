/// TonFun BCL Jetton master: bonding-curve minter that sells and buys back its own Jetton until the curve fills and liquidity moves to STON.fi.
contract TonFunBclMasterV1 {
    author: "TonFun"
    version: "1.0"
    description: "TonFun BCL Master mints Jettons along a bonding curve for GRAM, buys them back on sell notifications from its wallets, and seeds a STON.fi pool once the curve is filled."
    storage: TonFunBclMasterStorage
    incomingMessages: TonFunBclMasterIncomingMessage
    outgoingMessages: TonFunBclMasterOutgoingMessage
    emittedEvents: TonFunBclMasterEvent
}

/// Router addresses used when the collected liquidity is deposited.
struct TonFunBclMasterRouterInfo {
    /// STON.fi router.
    routerAddress: address
    /// Router pTON wallet that receives the GRAM leg.
    routerPtonWalletAddress: address
}

/// Bonding-curve parameters referenced from the base storage.
struct TonFunBclMasterBclParams {
    /// Supply sold along the curve before trading closes.
    bclSupply: coins
    /// Supply minted for the liquidity pool once trading closes.
    liqSupply: coins
    /// Token author.
    authorAddress: address
    /// Recipient of trade fees.
    feeAddress: address
    /// Trade fee numerator.
    tradeFeeNumerator: uint16
    /// Trade fee denominator.
    tradeFeeDenominator: uint16
    /// Whether buys and sells are accepted.
    tradingEnabled: bool
    /// Referral cell recorded at deployment.
    referral: cell
    /// Deployment seed.
    seed: uint64
    /// Fee paid when trading closes.
    tradingCloseFee: coins
    /// Router addresses for the liquidity deposit.
    routerInfo: Cell<TonFunBclMasterRouterInfo>
}

/// Persistent master state.
struct TonFunBclMasterStorage {
    /// Total minted supply.
    totalSupply: coins
    /// Admin allowed to change fees, content and code.
    adminAddress: address
    /// Jetton content cell.
    content: cell
    /// Jetton wallet code.
    walletCode: cell
    /// Unix time of the last buy or sell.
    lastTradeDate: uint32
    /// GRAM collected for liquidity.
    tonLiqCollected: coins
    /// GRAM the curve collects in total.
    maxTon: coins
    /// Recipient of the LP tokens.
    lpReceiver: address
    /// Bonding-curve parameters.
    bclParams: Cell<TonFunBclMasterBclParams>
}

/// GRAM purchase along the curve; the buyer defaults to the sender unless an address follows the referral.
struct (0xaf750d34) TonFunBclMasterBuy {
    /// Query id copied into the mint and log bodies.
    queryId: uint64
    /// Minimum Jetton amount the buyer accepts.
    minReceiveAmount: coins
    /// Optional referral cell copied into the fee payout and the log.
    referral: cell?
    /// Optional buyer address; empty when the sender buys for itself.
    buyerAddress: RemainingBitsAndRefs
}

/// Sell request forwarded by a BCL wallet.
struct (0x68e870fe) TonFunBclMasterSellCoinsNotification {
    /// Query id copied into the payout and the log.
    queryId: uint64
    /// Jetton amount sold.
    amount: coins
    /// Minimum GRAM the seller accepts.
    minReceiveAmount: coins
    /// Wallet owner receiving the GRAM.
    ownerAddress: address
    /// Optional referral cell copied into the fee payout and the log.
    referral: cell?
}

/// Unlock request forwarded by a BCL wallet once trading has closed.
struct (0x4d583549) TonFunBclMasterUnlockWalletCallback {
    /// Query id copied into the excess reply.
    queryId: uint64
    /// Wallet owner asking to unlock transfers.
    ownerAddress: address
}

/// Standard burn notification from a BCL wallet.
struct (0x7bdd97de) TonFunBclMasterBurnNotification {
    /// Query id copied into the excess reply.
    queryId: uint64
    /// Burned Jetton amount.
    amount: coins
    /// Wallet owner.
    ownerAddress: address
    /// Address that receives the excess GRAM.
    responseDestination: address?
}

/// TEP-89 wallet address discovery request.
struct (0x2c76b973) TonFunBclMasterProvideWalletAddress {
    /// Query id copied into the reply.
    queryId: uint64
    /// Owner whose wallet address is requested.
    ownerAddress: address
    /// Whether the reply repeats the owner address.
    includeAddress: bool
}

/// Admin command replacing the admin address.
struct (0x4d5f2cca) TonFunBclMasterSetAdmin {
    /// Query id of the command.
    queryId: uint64
    /// New admin.
    adminAddress: address
}

/// Admin command replacing the Jetton content.
struct (0xfadc0412) TonFunBclMasterSetContent {
    /// Query id of the command.
    queryId: uint64
    /// New content cell.
    content: cell
}

/// Admin command replacing the fee recipient and the fee ratio.
struct (0x4b89c3d4) TonFunBclMasterSetFees {
    /// Query id of the command.
    queryId: uint64
    /// New fee recipient.
    feeAddress: address
    /// New trade fee numerator.
    tradeFeeNumerator: uint16
    /// New trade fee denominator.
    tradeFeeDenominator: uint16
}

/// Admin command replacing the contract code.
struct (0x9c0f3220) TonFunBclMasterSetCode {
    /// Query id of the command.
    queryId: uint64
    /// New code.
    code: cell
}

/// Admin command replacing the contract data.
struct (0x46e9f1db) TonFunBclMasterSetData {
    /// Query id of the command.
    queryId: uint64
    /// New data.
    data: cell
}

/// Admin command replacing both code and data.
struct (0xbd9d1e7d) TonFunBclMasterSetCodeData {
    /// Query id of the command.
    queryId: uint64
    /// New code.
    code: cell
    /// New data.
    data: cell
}

/// Transfer notification from the master's own LP Jetton wallet; the tokens are burned.
struct (0x7362d09c) TonFunBclMasterTransferNotification {
    /// Query id copied into the burn transfer.
    queryId: uint64
    /// Received Jetton amount.
    amount: coins
    /// Sender of the tokens.
    senderAddress: address?
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Plain top-up accepted without processing.
struct (0xd372158c) TonFunBclMasterTopUp {
    /// Query id of the top-up.
    queryId: uint64
}

/// Excess return accepted without processing.
struct (0xd53276db) TonFunBclMasterExcesses {
    /// Query id of the excess.
    queryId: uint64
}

/// Internal message bodies accepted by the master.
type TonFunBclMasterIncomingMessage =
    | TonFunBclMasterBuy
    | TonFunBclMasterSellCoinsNotification
    | TonFunBclMasterUnlockWalletCallback
    | TonFunBclMasterBurnNotification
    | TonFunBclMasterProvideWalletAddress
    | TonFunBclMasterSetAdmin
    | TonFunBclMasterSetContent
    | TonFunBclMasterSetFees
    | TonFunBclMasterSetCode
    | TonFunBclMasterSetData
    | TonFunBclMasterSetCodeData
    | TonFunBclMasterTransferNotification
    | TonFunBclMasterTopUp
    | TonFunBclMasterExcesses

/// Mint sent to the buyer's wallet.
struct (0x178d4519) TonFunBclMasterInternalTransfer {
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

/// Trade fee sent to the fee recipient; no query id, only the referral cell.
struct (0xfdaa7c9d) TonFunBclMasterFeePayout {
    /// Referral cell copied from the trade.
    referral: cell?
}

/// Excess returned to the wallet after an unlock.
struct (0xa8ce3fe7) TonFunBclMasterUnlockWalletExcess {
    /// Query id copied from the unlock callback.
    queryId: uint64
}

/// TEP-89 wallet address discovery reply.
struct (0xd1735400) TonFunBclMasterTakeWalletAddress {
    /// Query id copied from the request.
    queryId: uint64
    /// Wallet address of the requested owner.
    walletAddress: address
    /// Owner address repeated on request.
    ownerAddress: cell?
}

/// Burn of LP tokens received by transfer notification, sent to the master's own LP wallet.
struct (0x0f8a7ea5) TonFunBclMasterTransfer {
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

/// GRAM payout to the seller with a text comment.
struct (0x00000000) TonFunBclMasterPayoutComment {
    /// Comment text.
    text: RemainingBitsAndRefs
}

/// Internal message bodies emitted by the master.
type TonFunBclMasterOutgoingMessage =
    | TonFunBclMasterInternalTransfer
    | TonFunBclMasterFeePayout
    | TonFunBclMasterUnlockWalletExcess
    | TonFunBclMasterTakeWalletAddress
    | TonFunBclMasterTransfer
    | TonFunBclMasterPayoutComment
    | TonFunBclMasterExcesses

/// External log emitted after a buy.
struct (0xcd78325d) TonFunBclMasterBuyLog {
    /// Buyer that received the tokens.
    buyerAddress: address
    /// GRAM consumed by the purchase.
    tonAmount: coins
    /// Jetton amount minted.
    supplyDelta: coins
    /// Total supply after the buy.
    newSupply: coins
    /// GRAM collected for liquidity after the buy.
    tonLiqCollected: coins
    /// Referral cell copied from the buy.
    referral: cell?
}

/// External log emitted after a sell.
struct (0x5e97d116) TonFunBclMasterSellLog {
    /// Seller that received the GRAM.
    sellerAddress: address
    /// GRAM returned to the seller.
    tonAmount: coins
    /// Jetton amount burned.
    supplyDelta: coins
    /// Total supply after the sell.
    newSupply: coins
    /// GRAM collected for liquidity after the sell.
    tonLiqCollected: coins
    /// Referral cell copied from the sell.
    referral: cell?
}

/// External log emitted when the collected liquidity is sent to STON.fi.
struct (0x0f6ab54f) TonFunBclMasterSendLiqLog {
    /// GRAM leg of the liquidity.
    tonLiq: coins
    /// Jetton leg of the liquidity.
    liqSupply: coins
}

/// External event bodies emitted by the master.
type TonFunBclMasterEvent =
    | TonFunBclMasterBuyLog
    | TonFunBclMasterSellLog
    | TonFunBclMasterSendLiqLog

/// Standard Jetton master data.
struct TonFunBclMasterJettonData {
    /// Total minted supply.
    totalSupply: int
    /// Whether trading is enabled.
    mintable: bool
    /// Admin address.
    adminAddress: any_address
    /// Jetton content cell.
    jettonContent: cell
    /// Jetton wallet code.
    jettonWalletCode: cell
}

/// Fee and amount pair returned by the curve quotes.
struct TonFunBclMasterQuote {
    /// Fee charged in nanograms.
    fees: int
    /// Quoted amount.
    amount: int
}

/// Full bonding-curve state returned by `get_bcl_data`.
struct TonFunBclMasterBclData {
    /// Total minted supply.
    totalSupply: int
    /// Supply sold along the curve.
    bclSupply: int
    /// Supply reserved for liquidity.
    liqSupply: int
    /// Admin address.
    adminAddress: any_address
    /// Token author.
    authorAddress: address
    /// Jetton content cell.
    content: cell
    /// Fee recipient.
    feeAddress: address
    /// Trade fee numerator.
    tradeFeeNumerator: int
    /// Trade fee denominator.
    tradeFeeDenominator: int
    /// Deprecated, always zero.
    deprecated: int
    /// Unix time of the last trade.
    lastTradeDate: int
    /// Whether trading is enabled.
    tradingEnabled: bool
    /// GRAM collected for liquidity.
    tonLiqCollected: int
    /// Referral cell recorded at deployment.
    referral: cell
    /// Fee paid when trading closes.
    tradingCloseFee: int
    /// GRAM needed to buy the whole curve.
    fullPriceTonNeed: int
    /// Fees charged when buying the whole curve.
    fullPriceTonFees: int
    /// STON.fi router.
    routerAddress: address
    /// Router pTON wallet.
    routerPtonWalletAddress: address
}

/// Return the standard Jetton master data.
get fun get_jetton_data(): TonFunBclMasterJettonData {
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
get fun coins_for_tons(tons: int): TonFunBclMasterQuote {
    throw 0;
}

/// Quote the nanograms received for the given Jetton amount.
get fun tons_for_coins(coins: int): TonFunBclMasterQuote {
    throw 0;
}

/// Return the full bonding-curve state.
get fun get_bcl_data(): TonFunBclMasterBclData {
    throw 0;
}
