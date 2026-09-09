/// Standard public interface, suitable when only the Jetton Wallet interface is known
/// TEP-74 does not mandate storage, exit codes or the inter-wallet message format
contract GenericJettonWallet {
    description: "Standard Jetton Wallet interface from TEP-74; the concrete implementation and storage layout are unknown"
    incomingMessages: JettonTransfer | JettonBurn
    thrownErrors: StandardErrors
    outgoingMessages: JettonTransferNotification | JettonExcesses
}

/// Owner request to transfer Jettons to another owner
struct (0x0f8a7ea5) JettonTransfer {
    /// Request identifier carried into related notifications and refunds
    queryId: uint64
    /// Jettons to transfer in elementary units, without decimal scaling
    amount: coins
    /// Recipient owner whose Jetton wallet receives the tokens
    destination: any_address
    /// Address for excess native coins, or addr_none when no refund is requested
    responseDestination: any_address
    /// Optional referenced data for wallet-specific processing, encoded as Maybe ^Cell
    customPayload: cell?
    /// Native coins attached to the recipient notification, in nano units; zero skips it
    forwardTonAmount: coins
    /// Recipient notification body, carried inline or in a reference
    forwardPayload: JettonForwardPayload
}

/// Owner request to burn Jettons
struct (0x595f07bc) JettonBurn {
    /// Request identifier carried into the burn notification and refund
    queryId: uint64
    /// Jettons to destroy in elementary units, without decimal scaling
    amount: coins
    /// Address for excess native coins, or addr_none when no refund is requested
    responseDestination: any_address
    /// Optional referenced data for wallet-specific processing, encoded as Maybe ^Cell
    customPayload: cell?
}

/// Notification to the recipient owner when forwardTonAmount is positive
struct (0x7362d09c) JettonTransferNotification {
    /// Identifier copied from the original transfer request
    queryId: uint64
    /// Received Jettons in elementary units, without decimal scaling
    amount: coins
    /// Original sender's owner address, rather than the sending Jetton wallet
    sender: any_address
    /// Payload supplied by the sender for the recipient owner's application
    forwardPayload: JettonForwardPayload
}

/// Refund to the response destination after processing a transfer
struct (0xd53276db) JettonExcesses {
    /// Identifier copied from the transfer request to correlate the refund
    queryId: uint64
}

/// Either Cell ^Cell: a zero tag selects inline content and a one tag selects a reference
type JettonForwardPayload = JettonInlinePayload | JettonReferencedPayload

/// Application payload stored in the remainder of the message body after the zero tag
struct (0b0) JettonInlinePayload {
    /// All remaining bits and references, including an empty payload or a text comment
    payload: RemainingBitsAndRefs
}

/// Application payload stored in a separate cell after the one tag
struct (0b1) JettonReferencedPayload {
    /// Referenced payload cell; its format belongs to the recipient's application
    payload: cell
}

/// Four stack values returned by get_wallet_data, independent of the storage layout
struct JettonWalletData {
    /// Owned Jettons in elementary units, without decimal scaling
    balance: int
    /// Account authorized to request transfers and burns from this wallet
    owner: address
    /// Master contract that defines the Jetton represented by this wallet
    jetton: address
    /// Wallet code returned by the getter, separate from the wallet's persistent data
    jettonWalletCode: cell
}

/// Returns the balance, owner, master and wallet code
get fun get_wallet_data(): JettonWalletData {
    throw 0;
}

/// No implementation-specific exit codes are part of this standard interface
enum StandardErrors {}
