/// Standard TEP-74 Jetton Master interface without implementation-specific storage
contract JettonMaster {
    description: "Standard Jetton Master interface from TEP-74; the concrete implementation and storage layout are unknown"
    outgoingMessages: JettonMasterOutgoingMessage
}

/// Refund emitted after a burn when a response destination is provided
struct (0xd53276db) JettonExcesses {
    /// Query id copied from the burn request
    queryId: uint64
}

/// Internal message bodies emitted by the standard Jetton Master interface
type JettonMasterOutgoingMessage = JettonExcesses

/// Result returned by get_jetton_data
struct JettonData {
    /// Total Jetton supply in base units
    totalSupply: int
    /// Whether new Jettons can be minted
    mintable: bool
    /// Administrator address, or addr_none when absent
    adminAddress: any_address
    /// TEP-64 off-chain URI or on-chain metadata dictionary
    jettonContent: cell
    /// Code used to derive and deploy Jetton wallets
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
