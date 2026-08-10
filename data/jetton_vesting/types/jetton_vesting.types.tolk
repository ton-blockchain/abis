/// Jetton vesting contract that releases an available balance through a standard Jetton wallet.
contract JettonVesting {
    description: "Jetton vesting contract with owner-authenticated claims and standard Jetton transfer output."
    storage: JettonVestingStorage
    storageAtDeployment: JettonVestingDeploymentStorage
    incomingMessages: JettonVestingIncomingMessage
    outgoingMessages: JettonVestingOutgoingMessage
    thrownErrors: JettonVestingErrors
}

/// Runtime data after lazy initialization has completed.
struct JettonVestingStorage {
    /// Library dictionary reference used by the lazy initialization path.
    lazyInitializationLibrary: cell
    /// Runtime marker; active storage encodes this bit as true.
    isInitialized: bool
    /// Address slot used by initialization and settlement flows; its protocol role is unknown.
    unknownAddress0: address
    /// Owner authorized to claim vested balances and withdraw unreserved GRAM.
    ownerAddress: address
    /// Jetton wallet that receives emitted transfer requests.
    jettonWalletAddress: address
    /// Unix timestamp used as the beginning of the linear vesting calculation.
    vestingStartTime: uint32
    /// Vesting duration in Julian years of 31,556,926 seconds.
    vestingDurationYears: uint32
    /// Jetton balance that remains unreleased.
    remainingJettonAmount: coins
    /// Referenced total allocation and runtime flags.
    allocationState: Cell<JettonVestingAllocationState>
}

/// Referenced allocation state used by active storage.
struct JettonVestingAllocationState {
    /// Original Jetton allocation used as the base of the linear vesting calculation.
    totalJettonAmount: coins
    /// Runtime condition flag whose public protocol meaning is unknown.
    unknownFlag0: bool
    /// Runtime condition flag whose public protocol meaning is unknown.
    unknownFlag1: bool
}

/// Data accepted before the lazy initialization branch materializes runtime storage.
struct JettonVestingDeploymentStorage {
    /// Library dictionary reference used to construct runtime code and data.
    lazyInitializationLibrary: cell
    /// Deployment marker; pre-initialized storage encodes this bit as false.
    isInitialized: bool
    /// First deployment address slot; its public protocol role is unknown.
    unknownAddress0: address
    /// Second deployment address slot; its public protocol role is unknown.
    unknownAddress1: address
}

/// Owner-authenticated request to release currently vested Jettons.
struct (0xcf4f9373) JettonVestingClaimToken {
    /// Caller-selected identifier copied into the emitted Jetton transfer.
    queryId: uint64
    /// Caller-selected account that receives the released Jettons.
    destination: address
    /// Optional requested amount; absence releases all currently available Jettons.
    amount: coins?
    /// Optional address that receives excess GRAM from the destination Jetton wallet.
    responseDestination: address?
    /// GRAM amount forwarded by the destination Jetton wallet.
    forwardTonAmount: coins
    /// Inline or referenced application payload forwarded by the destination Jetton wallet.
    forwardPayload: RemainingBitsAndRefs
}

/// Owner-authenticated request to withdraw unreserved GRAM from the vesting contract.
struct (0x0393b1ce) JettonVestingClaimGram {
    /// Account that receives the unreserved GRAM balance.
    receiver: address
}

/// Request with a referenced protocol payload whose public operation name is unknown.
struct (0x678ed83d) JettonVestingOpcode678ed83d {
    /// Referenced payload forwarded unchanged by the contract.
    payload: cell
}

/// Balance-update request whose public operation name is unknown.
struct (0xb148d27f) JettonVestingOpcodeB148d27f {
    /// Jetton amount stored as the current and total allocation.
    amount: coins
}

/// Partial runtime-configuration update authorized by a fixed administrator.
struct (0xab800f82) JettonVestingOpcodeAb800f82 {
    /// Optional replacement for the vesting start timestamp.
    vestingStartTime: uint32?
    /// Optional replacement for the vesting duration in years.
    vestingDurationYears: uint32?
    /// Optional replacement for the remaining Jetton amount.
    remainingJettonAmount: coins?
    /// Optional replacement for the total Jetton allocation.
    totalJettonAmount: coins?
    /// Optional replacement for the first runtime condition flag.
    unknownFlag0: bool?
}

/// Runtime-flag update authorized by a fixed administrator.
struct (0x4665955b) JettonVestingOpcode4665955b {
    /// Replacement for the second runtime condition flag.
    unknownFlag1: bool
}

/// Jetton transfer request authorized by a fixed administrator.
struct (0x0ddabdd2) JettonVestingOpcode0ddabdd2 {
    /// Account that receives the transferred Jettons.
    destination: address
    /// Number of Jettons transferred to the destination.
    amount: coins
}

/// Internal request bodies accepted by the vesting contract.
type JettonVestingIncomingMessage =
    | JettonVestingClaimToken
    | JettonVestingClaimGram
    | JettonVestingOpcode678ed83d
    | JettonVestingOpcodeB148d27f
    | JettonVestingOpcodeAb800f82
    | JettonVestingOpcode4665955b
    | JettonVestingOpcode0ddabdd2

/// Standard Jetton transfer emitted toward the vesting contract's Jetton wallet.
struct (0x0f8a7ea5) JettonVestingJettonTransfer {
    /// Query identifier copied from the accepted claim request.
    queryId: uint64
    /// Vested Jetton amount selected by the contract.
    amount: coins
    /// Recipient copied from the accepted claim request.
    destination: address
    /// Optional address that receives excess GRAM from the destination Jetton wallet.
    responseDestination: address?
    /// Optional custom payload; the deployed vesting contract emits no custom payload.
    customPayload: cell?
    /// GRAM amount copied from the accepted claim request.
    forwardTonAmount: coins
    /// Inline or referenced payload copied from the accepted claim request.
    forwardPayload: RemainingBitsAndRefs
}

/// Standard Jetton excess-value response emitted to return unused attached GRAM.
struct (0xd53276db) JettonVestingExcesses {
    /// Query identifier of the completed Jetton operation.
    queryId: uint64
}

/// Response that carries an address and a referenced payload to the stored settlement address.
struct (0x39bacb5f) JettonVestingOpcode39bacb5f {
    /// Owner address stored by the vesting contract.
    ownerAddress: address
    /// Referenced payload copied from the triggering request.
    payload: cell
}

/// Body-bearing internal messages emitted by the vesting contract.
type JettonVestingOutgoingMessage =
    | JettonVestingJettonTransfer
    | JettonVestingExcesses
    | JettonVestingOpcode39bacb5f

/// Exit codes returned while validating messages, state, and vesting balances.
enum JettonVestingErrors {
    /// Incoming internal message does not match a supported receiver.
    InvalidIncomingMessage = 130
    /// A required lazy-initialization library entry is absent.
    MissingInitializationLibrary = 135
    /// Protected request was not sent by its authorized owner or fixed administrator.
    IncorrectSender = 9215
    /// The referenced-payload request is not valid in the current runtime state.
    InvalidReferencedPayloadState = 20150
    /// Requested Jetton amount exceeds the currently available vested amount.
    RequestedAmountExceedsAvailable = 20380
    /// The allocation update is not valid after an allocation has been installed.
    AllocationAlreadyInitialized = 26604
    /// No unreleased Jetton balance remains.
    NoRemainingJettons = 37124
    /// The referenced-payload request carries less than 0.2 GRAM.
    InsufficientAttachedValue = 46061
    /// Claims are disabled by the second runtime condition flag.
    ClaimsDisabled = 49077
    /// No newly vested Jettons are currently available for release.
    NoAvailableTokens = 54948
    /// The total Jetton allocation is zero.
    EmptyAllocation = 59621
}
