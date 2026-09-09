/// Standard TEP-74 Jetton Wallet interface without implementation-specific storage
contract JettonWallet {
    description: "Standard Jetton Wallet interface from TEP-74; the concrete implementation and storage layout are unknown"
    incomingMessages: JettonWalletIncomingMessage
    outgoingMessages: JettonWalletOutgoingMessage
}

/// Owner request to transfer Jettons to another owner
struct (0x0f8a7ea5) JettonTransfer {
    /// Query id copied into related notifications and refunds
    queryId: uint64
    /// Jetton amount to transfer, in base units
    amount: coins
    /// Destination owner address
    destination: any_address
    /// Refund address, or addr_none when no refund is requested
    responseDestination: any_address
    /// Optional referenced payload for wallet-specific processing
    customPayload: cell?
    /// Nanograms forwarded to the owner notification; zero skips the notification
    forwardTonAmount: coins
    /// Payload forwarded to the recipient owner
    forwardPayload: JettonForwardPayload
}

/// Jettons credited by another wallet or the master
struct (0x178d4519) JettonInternalTransfer {
    /// Query id copied from the transfer or mint request
    queryId: uint64
    /// Jetton amount to credit, in base units
    amount: coins
    /// Previous owner address, or addr_none for a mint without a sender
    from: address?
    /// Refund address, or addr_none when no refund is requested
    responseAddress: address?
    /// Nanograms forwarded to the owner notification
    forwardTonAmount: coins
    /// Payload forwarded to the recipient owner
    forwardPayload: JettonForwardPayload
}

/// Owner request to burn Jettons
struct (0x595f07bc) JettonBurn {
    /// Query id copied into the burn notification and refund
    queryId: uint64
    /// Jetton amount to burn, in base units
    amount: coins
    /// Refund address, or addr_none when no refund is requested
    responseDestination: any_address
    /// Optional referenced payload for wallet-specific processing
    customPayload: cell?
}

/// Notification to the recipient owner when forwardTonAmount is positive
struct (0x7362d09c) JettonTransferNotification {
    /// Query id copied from the transfer request
    queryId: uint64
    /// Received Jetton amount, in base units
    amount: coins
    /// Original sender's owner address
    sender: any_address
    /// Sender-provided payload for the recipient owner
    forwardPayload: JettonForwardPayload
}

/// Burn notification sent by a Jetton wallet to its master
struct (0x7bdd97de) JettonBurnNotification {
    /// Query id copied from the burn request
    queryId: uint64
    /// Burned Jetton amount, in base units
    amount: coins
    /// Owner of the wallet that burned the Jettons
    sender: address
    /// Refund address, or addr_none when no refund is requested
    responseDestination: address?
}

/// Refund to the response destination after processing a transfer
struct (0xd53276db) JettonExcesses {
    /// Query id copied from the transfer request
    queryId: uint64
}

/// Internal message bodies accepted by the standard Jetton Wallet interface
type JettonWalletIncomingMessage =
    | JettonTransfer
    | JettonInternalTransfer
    | JettonBurn

/// Internal message bodies emitted by the standard Jetton Wallet interface
type JettonWalletOutgoingMessage =
    | JettonInternalTransfer
    | JettonBurnNotification
    | JettonTransferNotification
    | JettonExcesses

/// TEP-74 forward payload encoded as Either Cell ^Cell
type JettonForwardPayload = JettonInlinePayload | JettonReferencedPayload

/// Inline forward payload with a zero tag
struct (0b0) JettonInlinePayload {
    /// Remaining payload bits and references
    payload: RemainingBitsAndRefs
}

/// Referenced forward payload with a one tag
struct (0b1) JettonReferencedPayload {
    /// Application-defined payload cell
    payload: cell
}

/// Result returned by get_wallet_data
struct JettonWalletData {
    /// Jetton balance in base units
    balance: int
    /// Owner authorized to request transfers and burns
    owner: address
    /// Jetton master address
    jetton: address
    /// Jetton wallet code
    jettonWalletCode: cell
}

/// Returns the balance, owner, master and wallet code
get fun get_wallet_data(): JettonWalletData {
    throw 0;
}
