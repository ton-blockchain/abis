/// One-time Getgems contract that holds value for a single Lucky Buy attempt.
contract GetgemsLuckyBuyAttempt {
    author: "Getgems"
    description: "One-time Getgems contract that resolves a single probabilistic NFT purchase attempt."
    storage: GetgemsLuckyBuyAttemptStorage
    incomingMessages: GetgemsLuckyBuyAttemptIncomingMessage
    incomingExternal: GetgemsLuckyBuyResolve
    forceAbiExport: GetgemsLuckyBuyAttemptRawAction | GetgemsLuckyBuyAttemptData
    thrownErrors: GetgemsLuckyBuyAttemptErrors
}

/// Mutable state and immutable request configuration retained for one attempt.
struct GetgemsLuckyBuyAttemptStorage {
    /// Lifecycle state: zero before funding, one pending, two executed, or three refunded.
    state: uint2
    /// GRAM amount received with the funding request, in nanoGRAM.
    fundedValue: coins
    /// Account that supplied the funding request, or `addr_none` before funding.
    fundingAddress: address?
    /// Unix timestamp recorded when the attempt was funded.
    fundedAt: uint32
    /// Identifier copied from the start request.
    attemptId: uint64
    /// Immutable signing, marketplace, nonce, and NFT parameters.
    config: Cell<GetgemsLuckyBuyAttemptConfig>
}

/// Immutable parameters committed into the attempt address at deployment.
struct GetgemsLuckyBuyAttemptConfig {
    /// Ed25519 public key authorized to sign the final outcome.
    decisionPublicKey: uint256
    /// Request participant address retained for the Lucky Buy flow.
    participantAddress: address
    /// Getgems marketplace address authorized to relay a raw action.
    marketplaceAddress: address
    /// Nonce required in the signed outcome.
    requestNonce: uint64
    /// Referenced NFT item address bound into the signed outcome by cell hash.
    nftItemAddress: Cell<address>
}

/// Start the attempt and move it from the deployment state to the pending state.
struct (0xb7e30a3e) GetgemsLuckyBuyStart {
    /// Caller-selected attempt identifier retained in persistent state.
    attemptId: uint64
}

/// Marketplace-authorized request that dispatches one complete raw message.
struct (0x26dd111d) GetgemsLuckyBuyAttemptMarketplaceRelay {
    /// Referenced send mode and complete raw message.
    action: Cell<GetgemsLuckyBuyAttemptRawAction>
}

/// TVM raw-message action executed by a marketplace relay.
struct GetgemsLuckyBuyAttemptRawAction {
    /// TVM send mode used to dispatch the referenced message.
    sendMode: uint8
    /// Complete outbound message passed to `send_raw_message`.
    message: cell
}

/// Signed external resolution that executes raw actions or refunds the attempt balance.
struct GetgemsLuckyBuyResolve {
    /// Ed25519 signature over all fields and actions that follow it.
    signature: bits512
    /// Outcome tag: two executes the referenced actions and three refunds the balance.
    action: uint2
    /// Unix timestamp after which the request is rejected.
    validUntil: uint32
    /// Nonce that must equal the immutable request nonce.
    requestNonce: uint64
    /// Hash of the referenced NFT item address cell in immutable configuration.
    nftItemAddressHash: uint256
    /// One send-mode byte per referenced complete outbound message.
    actions: RemainingBitsAndRefs
}

/// Values returned by the unnamed method with TVM id 129613.
struct GetgemsLuckyBuyAttemptData {
    /// Current lifecycle state.
    state: uint2
    /// GRAM amount received with the funding request, in nanoGRAM.
    fundedValue: coins
    /// Funding account, or `addr_none` before funding.
    fundingAddress: any_address
    /// Unix timestamp recorded when the attempt was funded.
    fundedAt: uint32
    /// Identifier copied from the start request.
    attemptId: uint64
    /// Ed25519 public key authorized to sign the final outcome.
    decisionPublicKey: uint256
    /// Request participant retained for the Lucky Buy flow.
    participantAddress: any_address
    /// Getgems marketplace authorized to relay a raw action.
    marketplaceAddress: any_address
    /// Nonce required in the signed outcome.
    requestNonce: uint64
    /// NFT item address cell whose hash is signed with the outcome.
    nftItemAddress: Cell<address>
}

/// Internal message bodies with fixed prefixes accepted by a Lucky Buy attempt.
type GetgemsLuckyBuyAttemptIncomingMessage =
    | GetgemsLuckyBuyStart
    | GetgemsLuckyBuyAttemptMarketplaceRelay

/// Exit codes reachable from Lucky Buy attempt validation paths.
enum GetgemsLuckyBuyAttemptErrors {
    /// Ed25519 signature validation failed.
    InvalidSignature = 35
    /// Funding was attempted after the deployment state.
    AlreadyFunded = 403
    /// Marketplace relay sender does not match immutable configuration.
    UnauthorizedMarketplaceRelay = 4031
    /// Stored configuration does not derive the current contract address.
    InvalidConfiguration = 104
    /// Signed outcome has expired.
    ExpiredDecision = 310
    /// Signed NFT item cell hash does not match immutable configuration.
    InvalidNftItemHash = 3101
    /// Signed request nonce does not match immutable configuration.
    InvalidRequestNonce = 3102
    /// Signed outcome was submitted outside the pending state.
    InvalidDecisionState = 3103
    /// Signed outcome tag is neither execute nor refund.
    UnsupportedDecision = 3104
    /// Internal message has neither a supported opcode nor an empty body.
    UnsupportedOperation = 65535
}

/// Return all mutable state and immutable request parameters.
get fun get_method_129613_xwm(): GetgemsLuckyBuyAttemptData {
    throw 0;
}
