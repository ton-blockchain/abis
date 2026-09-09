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
    queryId: uint64
    amount: coins
    destination: any_address
    responseDestination: any_address
    customPayload: cell?
    forwardTonAmount: coins
    forwardPayload: JettonForwardPayload
}

/// Owner request to burn Jettons
struct (0x595f07bc) JettonBurn {
    queryId: uint64
    amount: coins
    responseDestination: any_address
    customPayload: cell?
}

/// Notification to the recipient owner when forwardTonAmount is positive
struct (0x7362d09c) JettonTransferNotification {
    queryId: uint64
    amount: coins
    sender: any_address
    forwardPayload: JettonForwardPayload
}

/// Refund to the response destination after processing a transfer
struct (0xd53276db) JettonExcesses {
    queryId: uint64
}

/// Preserve the Either selector so inline and referenced payloads round-trip
type JettonForwardPayload = JettonInlinePayload | JettonReferencedPayload

struct (0b0) JettonInlinePayload {
    payload: RemainingBitsAndRefs
}

struct (0b1) JettonReferencedPayload {
    payload: cell
}

/// Getter result, not a schema for the persistent data cell
struct JettonWalletData {
    balance: int
    owner: address
    jetton: address
    jettonWalletCode: cell
}

/// Returns the balance, owner, master and wallet code
get fun get_wallet_data(): JettonWalletData {
    throw 0;
}

// Explicitly suppress errors inferred from interface-only getter stubs.
// TEP-74 does not specify implementation exit codes.
enum StandardErrors {}
