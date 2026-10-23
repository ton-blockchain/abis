/// Blum Memepad Jetton wallet: TEP-74 wallet with curve sell and unlock flows, transfers locked until the token is listed.
contract BlumMemepadWallet {
    author: "Blum"
    version: "2.0"
    description: "Blum Memepad Wallet holds a launchpad token, forwards sells to the minter while the curve is trading, and unlocks transfers after listing."
    storage: BlumMemepadWalletStorage
    incomingMessages: BlumMemepadWalletIncomingMessage
    outgoingMessages: BlumMemepadWalletOutgoingMessage
}

/// Persistent wallet state.
struct BlumMemepadWalletStorage {
    /// Jetton balance.
    balance: coins
    /// Wallet owner.
    ownerAddress: address
    /// Minter that deployed the wallet.
    jettonMasterAddress: address
    /// Whether transfers are unlocked.
    unlocked: bool
}

/// Standard transfer, accepted only after unlock.
struct (0x0f8a7ea5) BlumMemepadWalletTransfer {
    /// Query id copied into the internal transfer.
    queryId: uint64
    /// Jetton amount to move.
    amount: coins
    /// New owner.
    destination: address
    /// Address that receives the excess GRAM.
    responseDestination: address?
    /// Optional custom payload.
    customPayload: cell?
    /// GRAM forwarded to the new owner.
    forwardTonAmount: coins
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Standard internal transfer from the minter or another wallet.
struct (0x178d4519) BlumMemepadWalletInternalTransfer {
    /// Query id copied into the notification.
    queryId: uint64
    /// Jetton amount received.
    amount: coins
    /// Previous owner; empty for mints.
    fromAddress: address?
    /// Address that receives the excess GRAM.
    responseAddress: address?
    /// GRAM forwarded to the owner.
    forwardTonAmount: coins
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Standard burn.
struct (0x595f07bc) BlumMemepadWalletBurn {
    /// Query id copied into the notification.
    queryId: uint64
    /// Jetton amount to burn.
    amount: coins
    /// Address that receives the excess GRAM.
    responseDestination: address?
    /// Optional custom payload.
    customPayload: cell?
}

/// Owner request to sell tokens back to the curve.
struct (0x742b36d8) BlumMemepadWalletSell {
    /// Query id copied into the sell notification.
    queryId: uint64
    /// Jetton amount to sell.
    amount: coins
    /// Minimum GRAM the seller accepts.
    minTonAmount: coins
    /// Optional payload copied into the sell notification.
    customPayload: cell?
}

/// Owner request to unlock transfers once the token is listed.
struct (0xf0fd50bb) BlumMemepadWalletUnlock {
    /// Query id copied into the unlock request.
    queryId: uint64
}

/// Unlock approval from the minter.
struct (0xb964422d) BlumMemepadWalletUnlockApprove {
    /// Query id copied from the request.
    queryId: uint64
}

/// Internal message bodies accepted by the wallet.
type BlumMemepadWalletIncomingMessage =
    | BlumMemepadWalletTransfer
    | BlumMemepadWalletInternalTransfer
    | BlumMemepadWalletBurn
    | BlumMemepadWalletSell
    | BlumMemepadWalletUnlock
    | BlumMemepadWalletUnlockApprove

/// Standard transfer notification sent to the owner.
struct (0x7362d09c) BlumMemepadWalletTransferNotification {
    /// Query id copied from the transfer.
    queryId: uint64
    /// Jetton amount received.
    amount: coins
    /// Previous owner; empty for mints.
    senderAddress: address?
    /// Forward payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Standard excess return.
struct (0xd53276db) BlumMemepadWalletExcesses {
    /// Query id copied from the operation.
    queryId: uint64
}

/// Standard burn notification sent to the minter.
struct (0x7bdd97de) BlumMemepadWalletBurnNotification {
    /// Query id copied from the burn.
    queryId: uint64
    /// Burned Jetton amount.
    amount: coins
    /// Wallet owner.
    ownerAddress: address
    /// Address that receives the excess GRAM.
    responseDestination: address?
    /// Optional custom payload copied from the burn.
    customPayload: cell?
}

/// Sell forwarded to the minter.
struct (0xb7e76bfd) BlumMemepadWalletSellNotification {
    /// Query id copied from the sell.
    queryId: uint64
    /// Jetton amount sold.
    amount: coins
    /// Minimum GRAM the seller accepts.
    minTonAmount: coins
    /// Wallet owner receiving the GRAM.
    ownerAddress: address
    /// Optional payload copied from the sell.
    customPayload: cell?
}

/// Unlock forwarded to the minter.
struct (0x06ae173e) BlumMemepadWalletUnlockRequest {
    /// Query id copied from the unlock.
    queryId: uint64
    /// Wallet owner asking to unlock transfers.
    ownerAddress: address
}

/// Internal message bodies emitted by the wallet.
type BlumMemepadWalletOutgoingMessage =
    | BlumMemepadWalletInternalTransfer
    | BlumMemepadWalletTransferNotification
    | BlumMemepadWalletExcesses
    | BlumMemepadWalletBurnNotification
    | BlumMemepadWalletSellNotification
    | BlumMemepadWalletUnlockRequest

/// Standard Jetton wallet data.
struct BlumMemepadWalletData {
    /// Jetton balance.
    balance: int
    /// Wallet owner.
    ownerAddress: address
    /// Minter that deployed the wallet.
    jettonMasterAddress: address
    /// Jetton wallet code.
    jettonWalletCode: cell
}

/// Return the standard Jetton wallet data.
get fun get_wallet_data(): BlumMemepadWalletData {
    throw 0;
}

/// Return whether transfers are unlocked.
get fun get_unlocked(): bool {
    throw 0;
}
