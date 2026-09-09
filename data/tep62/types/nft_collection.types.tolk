/// Standard TEP-62 NFT Collection interface without implementation-specific storage
contract NftCollection {
    description: "Standard NFT Collection interface from TEP-62; the concrete implementation and storage layout are unknown"
}

/// Result returned by get_collection_data
struct NftCollectionData {
    /// Next item index, or -1 for a collection with non-sequential indexes
    nextItemIndex: int
    /// TEP-64 collection metadata
    collectionContent: cell
    /// Collection owner address; the zero address indicates no owner
    ownerAddress: any_address
}

/// Returns the next item index, collection metadata and owner
get fun get_collection_data(): NftCollectionData {
    throw 0;
}

/// Returns the NFT item address for the given collection index
get fun get_nft_address_by_index(index: int): any_address {
    throw 0;
}

/// Combines item index and individual content into full TEP-64 metadata
get fun get_nft_content(index: int, individualContent: cell): cell {
    throw 0;
}
