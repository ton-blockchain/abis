/// Standard public interface, suitable when only the Jetton Master interface is known
/// Storage, mint/admin operations and exit codes depend on the implementation
contract GenericJettonMaster {
    description: "Standard Jetton Master interface from TEP-74; the concrete implementation and storage layout are unknown"
    thrownErrors: StandardErrors
    outgoingMessages: JettonExcesses
}

/// Refund emitted after a burn when a response destination is provided
struct (0xd53276db) JettonExcesses {
    /// Identifier copied from the burn request to correlate the refund
    queryId: uint64
}

/// Five stack values returned by get_jetton_data, independent of the storage layout
struct JettonData {
    /// Issued supply in elementary Jetton units, without decimal scaling
    totalSupply: int
    /// Whether minting is enabled, returned as TVM true (-1) or false (0)
    mintable: bool
    /// Administrator encoded in a stack slice, including addr_none when absent
    adminAddress: any_address
    /// TEP-64 content cell containing an off-chain URI or on-chain metadata dictionary
    jettonContent: cell
    /// Wallet code used by the master to derive and deploy its Jetton wallets
    jettonWalletCode: cell
}

/// Returns supply, mintability, administrator, metadata and wallet code
get fun get_jetton_data(): JettonData {
    throw 0;
}

/// Returns the derived Jetton wallet address for ownerAddress, even before deployment
get fun get_wallet_address(ownerAddress: address): address {
    throw 0;
}

/// No implementation-specific exit codes are part of this standard interface
enum StandardErrors {}
