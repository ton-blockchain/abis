/// TON Storage aggregate contract interface for one torrent and its active providers.
contract StorageAggregateContract {
    author: "TON Core"
    version: "1.0"
    description: "TON Storage aggregate contract tracks one torrent and a dictionary of providers paid for storage proofs."
    storage: StorageAggregateContractStorage
    incomingMessages: StorageAggregateContractIncomingMessage
    outgoingMessages: StorageAggregateContractOutgoingMessage
    forceAbiExport: StorageAggregateProvider | StorageAggregateProviderInfo
    thrownErrors: StorageAggregateContractErrors
}

/// Persistent state of the aggregate storage contract.
struct StorageAggregateContractStorage {
    /// Torrent hash identifying the stored bag metadata.
    torrentHash: uint256
    /// Providers keyed by their 256-bit Ed25519 public keys.
    activeProviders: map<uint256, StorageAggregateProvider>
    /// Owner address authorized to replace providers and withdraw balance above the 0.005 GRAM reserve.
    owner: address
    /// Size of the stored file in bytes.
    fileSize: uint64
    /// Size of one Merkle-tree chunk in bytes.
    chunkSize: uint32
    /// Root hash of the file Merkle tree.
    merkleHash: uint256
    /// Number of Merkle-branch key bits used to locate a proof chunk.
    keyLength: uint8
}

/// Mutable proof state stored for one active provider.
struct StorageAggregateProvider {
    /// Byte offset selected for the provider's next proof.
    nextProofByte: uint64
    /// Unix timestamp of the provider's last accepted proof.
    lastProofTime: uint32
    /// Nonce required in the provider's next proof message.
    nonce: uint64
    /// Referenced provider payment terms.
    info: Cell<StorageAggregateProviderInfo>
}

/// Payment terms configured for one provider.
struct StorageAggregateProviderInfo {
    /// Maximum paid interval between proofs, in seconds.
    paymentMaxSpan: uint32
    /// Storage price in nanograms per MiB per day.
    ratePerMbDay: coins
}

/// Opcode-zero body accepted as a balance top-up or text comment.
struct (0x00000000) StorageAggregateTopUp {
    /// Optional raw comment or payload ignored by the contract.
    tail: RemainingBitsAndRefs
}

/// Provider request carrying a signed Merkle proof for its next challenged byte.
struct (0x48f548ce) StorageAggregateProofStorage {
    /// Query identifier copied into the reward-withdrawal response.
    queryId: uint64
    /// Provider Ed25519 public key used as the provider dictionary key.
    key: uint256
    /// Ed25519 signature over the signed message tail.
    signature: bits512
    /// Nonce that must match the provider's stored challenge nonce.
    nonce: uint64
    /// Referenced exotic Merkle-proof cell for the challenged file chunk.
    proof: cell
}

/// Owner request replacing the configured set of provider payment terms.
struct (0x3dc680ae) StorageAggregateModifyProviders {
    /// Owner-supplied query identifier.
    queryId: uint64
    /// Replacement provider terms keyed by 256-bit provider public keys.
    providers: map<uint256, StorageAggregateProviderInfo>
}

/// Owner request to withdraw the available balance and emit a termination notification.
struct (0x61fff683) StorageAggregateWithdrawOwner {
    /// Owner-supplied query identifier consumed by the request.
    queryId: uint64
}

/// Reward notification sent to a provider after an accepted storage proof.
struct (0xa91baf56) StorageAggregateRewardWithdrawal {
    /// Query identifier copied from the accepted proof request.
    queryId: uint64
}

/// Termination notification sent to the owner during owner withdrawal.
struct (0xb6236d63) StorageAggregateContractTerminated {
    /// Contract logical time at which termination was requested.
    curLt: uint64
    /// Torrent hash identifying the terminated aggregate storage service.
    torrentHash: uint256
}

/// Internal message bodies accepted by the aggregate storage contract.
type StorageAggregateContractIncomingMessage =
    | StorageAggregateTopUp
    | StorageAggregateProofStorage
    | StorageAggregateModifyProviders
    | StorageAggregateWithdrawOwner

/// Internal message bodies emitted by the aggregate storage contract.
type StorageAggregateContractOutgoingMessage =
    | StorageAggregateRewardWithdrawal
    | StorageAggregateContractTerminated

/// Core torrent information returned by `get_storage_info`.
struct StorageAggregateInfoReply {
    /// Torrent hash identifying the stored bag metadata.
    torrentHash: uint256
    /// Size of the stored file in bytes.
    fileSize: uint64
    /// Size of one Merkle-tree chunk in bytes.
    chunkSize: uint32
    /// Owner address authorized to manage providers and withdraw funds.
    owner: any_address
    /// Root hash of the file Merkle tree.
    merkleHash: uint256
}

/// Provider proof state, payment terms, and contract balance returned by `get_provider_info`.
struct StorageAggregateProviderInfoReply {
    /// Nonce required in the provider's next proof message.
    nonce: uint64
    /// Unix timestamp of the provider's last accepted proof.
    lastProofTime: uint32
    /// Byte offset selected for the provider's next proof.
    nextProofByte: uint64
    /// Maximum paid interval between proofs, in seconds.
    paymentMaxSpan: uint32
    /// Storage price in nanograms per MiB per day.
    ratePerMbDay: coins
    /// Current contract balance less the reserved 0.005 GRAM, in nanograms.
    availableContractBalance: coins
}

/// Provider tuple collection and spendable balance returned by `get_providers`.
struct StorageAggregateProvidersReply {
    /// Tuple of provider entries containing key, rate, span, proof time, proof byte, and nonce.
    providers: tuple
    /// Contract balance available above the reserved 0.005 GRAM, in nanograms.
    availableBalance: coins
}

/// Exit codes thrown by aggregate storage validation and lookup paths.
enum StorageAggregateContractErrors {
    /// Merkle proof cell is not an exotic cell.
    ProofCellIsNotExotic = 13
    /// Merkle proof cell does not carry the expected proof tag.
    InvalidProofTag = 14
    /// Merkle proof root does not match the stored Merkle hash.
    InvalidProofRoot = 15
    /// Resolved Merkle branch does not contain exactly 256 data bits.
    InvalidProofChunk = 16
    /// Sender, signature, provider key, or proof nonce is not authorized.
    Unauthorized = 401
    /// Requested provider key is absent from persistent storage.
    ProviderNotFound = 404
    /// Provider replacement contains at least 512 entries.
    TooManyProviders = 406
    /// Provider payment span must be greater than zero.
    PaymentSpanIsZero = 407
    /// Provider storage rate must be greater than zero.
    StorageRateIsZero = 408
    /// Incoming internal messages must originate from base workchain zero.
    UnsupportedWorkchain = 111
}

/// Return the torrent identity, file geometry, owner, and Merkle root.
get fun get_storage_info(): StorageAggregateInfoReply {
    throw 0;
}

/// Return proof state and payment terms for a provider public key.
get fun get_provider_info(key: uint256): StorageAggregateProviderInfoReply {
    throw 0;
}

/// Return the contract balance available above its reserved 0.005 GRAM.
get fun get_available_balance(): coins {
    throw 0;
}

/// Return all provider entries and the currently available contract balance.
get fun get_providers(): StorageAggregateProvidersReply {
    throw 0;
}
