/// Standard public interface, suitable when only the Jetton Master interface is known
/// Storage, mint/admin operations and exit codes depend on the implementation
contract GenericJettonMaster {
    description: "Standard Jetton Master interface from TEP-74; the concrete implementation and storage layout are unknown"
    thrownErrors: StandardErrors
    outgoingMessages: JettonExcesses
}

/// Refund emitted after a burn when a response destination is provided
struct (0xd53276db) JettonExcesses {
    queryId: uint64
}

/// Getter result, not a schema for the persistent data cell
struct JettonData {
    totalSupply: int
    mintable: bool
    /// May be addr_none for a master without an administrator
    adminAddress: any_address
    /// Metadata encoded according to TEP-64
    jettonContent: cell
    jettonWalletCode: cell
}

/// Returns supply, mintability, administrator, metadata and wallet code
get fun get_jetton_data(): JettonData {
    throw 0;
}

/// Returns the Jetton wallet address for the given owner
get fun get_wallet_address(ownerAddress: address): address {
    throw 0;
}

// Explicitly suppress errors inferred from interface-only getter stubs.
// TEP-74 does not specify implementation exit codes.
enum StandardErrors {}
