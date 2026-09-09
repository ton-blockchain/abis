/// Standard TEP-62 NFT Item interface without implementation-specific storage
contract NftItem {
    description: "Standard NFT Item interface from TEP-62; the concrete implementation and storage layout are unknown"
    incomingMessages: NftItemIncomingMessage
    outgoingMessages: NftItemOutgoingMessage
}

/// Owner request to transfer the NFT
struct (0x5fcc3d14) NftTransfer {
    /// Query id copied into related notifications and refunds
    queryId: uint64
    /// New owner address
    newOwner: address
    /// Refund address, or addr_none when no refund is requested
    responseDestination: address?
    /// Optional referenced custom payload
    customPayload: cell?
    /// Nanograms forwarded to the new owner; zero skips the notification
    forwardAmount: coins
    /// Payload forwarded to the new owner
    forwardPayload: NftForwardPayload
}

/// Request for the item's index and collection address
struct (0x2fcb26a2) NftGetStaticData {
    /// Query id copied into the static-data response
    queryId: uint64
}

/// Ownership notification sent to the new owner
struct (0x05138d91) NftOwnershipAssigned {
    /// Query id copied from the transfer request
    queryId: uint64
    /// Previous owner address
    prevOwner: address
    /// Payload supplied by the previous owner
    forwardPayload: NftForwardPayload
}

/// Static-data response sent to the requester
struct (0x8b771735) NftReportStaticData {
    /// Query id copied from the static-data request
    queryId: uint64
    /// Item index within the collection, or a constant index for a standalone NFT
    index: uint256
    /// Collection address, or addr_none for a standalone NFT
    collection: address?
}

/// Excess native coins returned after a transfer
struct (0xd53276db) NftExcesses {
    /// Query id copied from the transfer request
    queryId: uint64
}

/// Internal message bodies accepted by the standard NFT Item interface
type NftItemIncomingMessage =
    | NftTransfer
    | NftGetStaticData

/// Internal message bodies emitted by the standard NFT Item interface
type NftItemOutgoingMessage =
    | NftOwnershipAssigned
    | NftReportStaticData
    | NftExcesses

/// TEP-62 forward payload encoded as Either Cell ^Cell
type NftForwardPayload = NftInlinePayload | NftReferencedPayload

/// Inline forward payload with a zero tag
struct (0b0) NftInlinePayload {
    /// Remaining payload bits and references
    payload: RemainingBitsAndRefs
}

/// Referenced forward payload with a one tag
struct (0b1) NftReferencedPayload {
    /// Application-defined payload cell
    payload: cell
}

/// Result returned by get_nft_data
struct NftData {
    /// Whether the NFT is initialized and ready for interaction
    isInitialized: bool
    /// Item index within the collection, or a constant index for a standalone NFT
    index: int
    /// Collection address, or addr_none for a standalone NFT
    collectionAddress: any_address
    /// Current owner address; null while the item is uninitialized
    ownerAddress: any_address?
    /// Collection-specific content, or full TEP-64 metadata for a standalone NFT
    /// Null while the item is uninitialized
    individualContent: cell?
}

/// Returns initialization status, index, collection, owner and individual content
get fun get_nft_data(): NftData {
    throw 0;
}
