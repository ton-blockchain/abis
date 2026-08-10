/// DeDust x1000 trading wallet interface for signed batched actions and routed callbacks.
contract DedustX1000WalletV2 {
    author: "DeDust"
    version: "2.0"
    description: "DeDust x1000 trading wallet for signed requests, batched actions, and routed protocol callbacks."
    storage: DedustX1000WalletV2Storage
    incomingMessages: DedustX1000WalletV2ExecuteStoredMessage
    incomingExternal: DedustX1000WalletV2SignedRequest
    outgoingMessages: DedustX1000WalletV2OutgoingMessage
    emittedEvents: DedustX1000WalletV2Event
    forceAbiExport: DedustX1000WalletV2ProtocolPayload | DedustX1000WalletV2InternalMessage
    thrownErrors: DedustX1000WalletV2Errors
}

/// Persistent wallet state with application-defined runtime dictionaries and action configuration.
struct DedustX1000WalletV2Storage {
    /// Storage layout revision.
    storageVersion: uint8
    /// Application-defined counter.
    counter0: uint32
    /// Sequence number consumed and incremented by accepted signed requests.
    seqno: uint32
    /// Ed25519 public key used to authorize signed wallet requests.
    publicKey: uint256
    /// Referenced runtime dictionaries with application-defined keys and values.
    runtimeState: cell
    /// Referenced action-dispatch configuration tree.
    implementationState: cell
}

/// Signed external wallet request with a session and batched-action tail.
struct DedustX1000WalletV2SignedRequest {
    /// Ed25519 signature checked against the public key in storage.
    signature: bits512
    /// Expected wallet sequence number used for replay protection.
    seqno: uint32
    /// Signed session and batched-action payload after the common prefix.
    payload: RemainingBitsAndRefs
}

/// Internal callback envelope with a common correlation prefix and handler-specific tail.
struct DedustX1000WalletV2InternalCallback {
    /// Callback operation identifier used by the routed handler.
    opcode: uint32
    /// Callback correlation identifier.
    requestId: uint64
    /// Handler-specific payload after the common prefix.
    payload: RemainingBitsAndRefs
}

/// Controller callback that releases a stored outgoing message for execution.
struct (0x01010202) DedustX1000WalletV2ExecuteStoredMessage {
    /// Stored-message correlation identifier.
    requestId: uint64
    /// Optional callback data ignored by the fixed execution branch.
    payload: RemainingBitsAndRefs
}

/// Internal callback bodies accepted by the wallet.
type DedustX1000WalletV2InternalMessage = DedustX1000WalletV2InternalCallback

/// Outbound controller request for execution of a stored message.
struct (0x01010201) DedustX1000WalletV2ExecutionRequested {
    /// Stored-message correlation identifier.
    requestId: uint64
}

/// TEP-74 Jetton transfer emitted to a Jetton wallet.
struct (0x0f8a7ea5) DedustX1000WalletV2JettonTransfer {
    /// Caller-selected correlation identifier.
    queryId: uint64
    /// Jetton quantity in token base units.
    amount: coins
    /// Owner address whose Jetton wallet receives the transfer.
    destination: address
    /// Optional destination for excess GRAM refunds.
    responseDestination: address?
    /// Optional application-specific payload stored by reference.
    customPayload: cell?
    /// GRAM amount forwarded with the recipient notification, in nanograms.
    forwardAmount: coins
    /// Optional forward payload stored by reference.
    forwardPayload: Cell<RemainingBitsAndRefs>?
}

/// DeDust swap direction that treats the supplied amount as input.
struct (0b0) DedustX1000GivenIn {}

/// DeDust swap direction that treats the requested amount as output.
struct (0b1) DedustX1000GivenOut {}

/// DeDust swap direction variants.
type DedustX1000SwapKind = DedustX1000GivenIn | DedustX1000GivenOut

/// One DeDust swap route step.
struct DedustX1000SwapStep {
    /// Pool that executes this step.
    poolAddress: address
    /// Exact-input or exact-output mode.
    kind: DedustX1000SwapKind
    /// Minimum output or maximum input for the selected mode.
    limit: coins
    /// Optional next route step stored by reference.
    next: Cell<DedustX1000SwapStep>?
}

/// DeDust whole-swap routing options.
struct DedustX1000SwapParams {
    /// Unix deadline, or zero when disabled.
    deadline: uint32
    /// Optional final asset recipient.
    recipientAddress: address?
    /// Optional referral recipient.
    referralAddress: address?
    /// Optional fulfillment payload stored by reference.
    fulfillPayload: cell?
    /// Optional rejection payload stored by reference.
    rejectPayload: cell?
}

/// DeDust Vault swap payload embedded in a Jetton transfer.
struct (0xe3a0d482) DedustX1000DedustSwapPayload {
    /// First swap route step stored inline.
    step: DedustX1000SwapStep
    /// Whole-swap options stored by reference.
    params: Cell<DedustX1000SwapParams>
}

/// STON.fi V2 additional swap parameters.
struct DedustX1000StonfiV2SwapBody {
    /// Minimum accepted output amount in token base units.
    minOut: coins
    /// Optional final receiver.
    receiver: address?
    /// Nanograms forwarded with a success notification.
    forwardGas: coins
    /// Optional success notification payload.
    customPayload: cell?
    /// Nanograms forwarded with a refund notification.
    refundForwardGas: coins
    /// Optional refund notification payload.
    refundPayload: cell?
    /// Referral fee in STON.fi fee units.
    referralFee: uint16
    /// Optional referral address.
    referralAddress: address?
}

/// STON.fi V2 swap payload embedded in a Jetton transfer.
struct (0x6664de2a) DedustX1000StonfiV2SwapPayload {
    /// Router-owned wallet for the other asset.
    tokenWallet: address
    /// Address receiving refunded tokens.
    refundAddress: address
    /// Address receiving excess GRAM.
    excessAddress: address
    /// Unix deadline for execution.
    deadline: uint64
    /// Swap limits and notification options stored by reference.
    swapBody: Cell<DedustX1000StonfiV2SwapBody>
}

/// TONCO multi-hop callback configuration.
struct DedustX1000ToncoMultihop {
    /// Next-hop target.
    targetAddress: address
    /// Nanograms forwarded after success.
    fulfillForwardAmount: coins
    /// Optional success payload.
    fulfillPayload: cell?
    /// Nanograms forwarded after rejection.
    rejectForwardAmount: coins
    /// Optional rejection payload.
    rejectPayload: cell?
    /// Address receiving excess GRAM.
    excessAddress: address
}

/// TONCO swap payload embedded in a Jetton transfer.
struct (0xa7fb58f8) DedustX1000ToncoSwapPayload {
    /// Target Pool Jetton wallet.
    targetJettonWallet: address
    /// Q96 square-root price boundary.
    sqrtPriceLimitX96: uint160
    /// Minimum accepted output amount.
    minOut: coins
    /// Owner of the swap.
    ownerAddress: address
    /// Optional next-hop configuration.
    multihop: Cell<DedustX1000ToncoMultihop>?
}

/// Optional CPMM route continuation.
struct DedustX1000CpmmNextStep {
    /// Pool that executes the next route step.
    poolAddress: address
    /// Minimum accepted output amount.
    minOut: coins
    /// Unix deadline for the next step.
    deadline: uint40
    /// Optional following route step.
    next: Cell<DedustX1000CpmmNextStep>?
}

/// CPMM partner fee attribution.
struct DedustX1000CpmmPartnerConfig {
    /// Partner identifier.
    partnerId: uint256
    /// Partner fee in basis points.
    feeBps: uint16
}

/// CPMM referrer fee attribution.
struct DedustX1000CpmmReferrerConfig {
    /// Referrer identifier.
    referrerId: uint256
    /// Referrer fee in basis points.
    feeBps: uint16
}

/// DeDust CPMM swap operation payload.
struct (0xc442500f) DedustX1000CpmmSwapPayload {
    /// Minimum accepted output amount.
    minOut: coins
    /// Unix deadline encoded in 40 bits.
    deadline: uint40
    /// Optional next route step.
    next: Cell<DedustX1000CpmmNextStep>?
    /// Optional partner attribution.
    partner: DedustX1000CpmmPartnerConfig?
    /// Optional referrer attribution.
    referrer: DedustX1000CpmmReferrerConfig?
}

/// CPMM payout path options.
struct DedustX1000CpmmPayoutOptions {
    /// Optional asset recipient.
    destination: address?
    /// Additional downstream gas in nanograms.
    extraGas: coins
    /// Optional downstream payload.
    payload: cell?
    /// Whether the payload is wrapped in a result envelope.
    wrapPayload: bool
}

/// CPMM fulfillment and rejection payout configuration.
@overflow1023_policy("suppress")
struct DedustX1000CpmmPayoutConfig {
    /// Fulfillment path options.
    fulfill: DedustX1000CpmmPayoutOptions
    /// Rejection path options.
    reject: DedustX1000CpmmPayoutOptions
    /// Optional recipient of excess GRAM.
    excessAddress: address?
}

/// DeDust CPMM Jetton payment payload.
struct (0xcbc33949) DedustX1000CpmmPayJettonPayload {
    /// Referenced CPMM operation payload.
    operation: cell
    /// Payout routing stored by reference.
    payout: Cell<DedustX1000CpmmPayoutConfig>
}

/// Bidask DAMM optional referral data.
struct DedustX1000BidaskDammReferral {
    /// Referral address.
    referralAddress: address
    /// Referral fee in Bidask fee units.
    referralFee: uint16
}

/// Bidask DAMM swap payload embedded in a Jetton transfer.
struct (0xdd79732c) DedustX1000BidaskDammSwapPayload {
    /// Receiver of swap output.
    toAddress: address
    /// Minimum output or maximum input limit.
    slippage: coins
    /// Logical sender used for accounting.
    fromAddress: address
    /// Exact-output target, or zero for exact-input mode.
    exactOut: coins
    /// Optional referral configuration.
    referral: Cell<DedustX1000BidaskDammReferral>?
    /// Optional rejection payload.
    rejectPayload: cell?
    /// Optional fulfillment payload.
    fulfillPayload: cell?
}

/// Normal Bidask execution with a minimum output.
struct (0b0) DedustX1000BidaskNormalSlippage {
    /// Minimum accepted output amount.
    minOut: coins
}

/// Partial Bidask execution with a price boundary.
struct (0b1) DedustX1000BidaskPartialSlippage {
    /// Q256 square-root price boundary.
    sqrtPriceLimit: uint256
}

/// Bidask slippage variants.
type DedustX1000BidaskSlippage =
    | DedustX1000BidaskNormalSlippage
    | DedustX1000BidaskPartialSlippage

/// Bidask CLMM swap origin and referral data.
struct DedustX1000BidaskAdditionalData {
    /// Logical swap initiator.
    fromAddress: address
    /// Referral address.
    referralAddress: address
}

/// Bidask CLMM swap payload embedded in a Jetton transfer.
struct (0xc09da84e) DedustX1000BidaskClmmSwapPayload {
    /// Receiver of swap output.
    toAddress: address
    /// Normal or partial-execution price limit.
    slippage: DedustX1000BidaskSlippage
    /// Exact-output target, or zero for exact-input mode.
    exactOut: coins
    /// Optional origin and referral data.
    additionalData: Cell<DedustX1000BidaskAdditionalData>?
    /// Optional rejection payload.
    rejectPayload: cell?
    /// Optional fulfillment payload.
    fulfillPayload: cell?
}

/// Coffee swap route step.
struct DedustX1000CoffeeSwapStep {
    /// Basechain hash of the target pool address.
    poolAddressHash: uint256
    /// Minimum accepted output amount.
    minOut: coins
    /// Optional next route step.
    next: Cell<DedustX1000CoffeeSwapStep>?
}

/// Coffee callback destination and payload.
struct DedustX1000CoffeeNotification {
    /// Nanograms forwarded to the callback.
    forwardAmount: coins
    /// Callback body.
    payload: cell
}

/// Coffee success and failure callback configuration.
struct DedustX1000CoffeeNotifications {
    /// Optional success callback.
    fulfill: Cell<DedustX1000CoffeeNotification>?
    /// Optional failure callback.
    reject: Cell<DedustX1000CoffeeNotification>?
}

/// Coffee whole-swap options.
struct DedustX1000CoffeeSwapParams {
    /// Unix deadline.
    deadline: uint32
    /// Final swap recipient.
    recipient: address
    /// Optional referral address.
    referral: address?
    /// Optional callback configuration.
    notifications: Cell<DedustX1000CoffeeNotifications>?
}

/// Coffee swap payload embedded in a Jetton transfer.
struct (0xc0ffee10) DedustX1000CoffeeSwapPayload {
    /// First swap route step.
    step: DedustX1000CoffeeSwapStep
    /// Optional whole-swap options.
    params: Cell<DedustX1000CoffeeSwapParams>?
}

/// Moon callback destination and optional body.
struct DedustX1000MoonCallback {
    /// Contract receiving the callback.
    recipient: address?
    /// Optional callback body stored by reference.
    payload: Cell<RemainingBitsAndRefs>?
}

/// Moon swap limits and callback routing.
struct DedustX1000MoonSwapParams {
    /// Minimum accepted output amount.
    minOut: coins
    /// Unix deadline.
    deadline: uint64
    /// Optional recipient of excess GRAM.
    excessAddress: address?
    /// Optional referral address.
    referralAddress: address?
    /// Optional success callback.
    fulfill: Cell<DedustX1000MoonCallback>?
    /// Optional rejection callback.
    reject: Cell<DedustX1000MoonCallback>?
}

/// Moon swap payload embedded in a Jetton transfer.
struct (0xb37a900b) DedustX1000MoonSwapPayload {
    /// Swap limits and callback routing.
    params: DedustX1000MoonSwapParams
}

/// Moon success callback body produced by the x1000 route.
struct (0xcb7f38d6) DedustX1000MoonSwapSucceeded {
    /// Correlation identifier copied from the wallet request.
    requestId: uint64
}

/// Moon failure callback body produced by the x1000 route.
struct (0xc47c1f57) DedustX1000MoonSwapFailed {
    /// Correlation identifier copied from the wallet request.
    requestId: uint64
}

/// Callback destination used by Moon CLMM routes.
struct DedustX1000MoonClmmCallback {
    /// Contract receiving the callback.
    recipient: address
    /// Optional callback payload.
    payload: cell?
}

/// Moon CLMM swap payload embedded in a Jetton transfer.
struct (0xd151210f) DedustX1000MoonClmmSwapPayload {
    /// Address receiving unused GRAM and the swap result.
    excessAddress: address
    /// Q128 square-root price boundary.
    sqrtPriceLimitX128: uint256
    /// Optional success callback.
    fulfill: Cell<DedustX1000MoonClmmCallback>?
    /// Optional rejection callback.
    reject: Cell<DedustX1000MoonClmmCallback>?
}

/// Application payload `0xfa45056b` with a coin value and two optional addresses.
struct (0xfa45056b) DedustX1000PayloadFa45056b {
    /// Application-defined coin value.
    unknown0: coins
    /// Application-defined optional address stored by reference.
    unknown1: Cell<address>?
    /// Application-defined optional address stored by reference.
    unknown2: Cell<address>?
}

/// STON.fi V1 swap payload embedded in a Jetton transfer.
@overflow1023_policy("suppress")
struct (0x25938561) DedustX1000StonfiV1SwapPayload {
    /// Router-owned wallet for the other asset.
    tokenWallet: address
    /// Minimum accepted output amount.
    minOut: coins
    /// Final output recipient.
    recipient: address
    /// Optional referral address.
    referralAddress: address?
}

/// StonksPump presale sell request emitted by the wallet.
struct (0xcc1a97af) DedustX1000StonksPumpSell {
    /// Caller-selected correlation identifier.
    queryId: uint64
    /// Jetton quantity sold in token base units.
    amount: coins
    /// Optional recipient of GRAM proceeds.
    proceedsRecipient: address?
    /// Minimum accepted GRAM proceeds in nanograms.
    minGramOut: coins
}

/// DeDust Uranus partner attribution.
struct DedustX1000UranusPartnerConfig {
    /// Partner identifier.
    partnerId: uint256
    /// Partner fee in basis points.
    feeBps: uint16
}

/// DeDust Uranus referrer attribution.
struct DedustX1000UranusReferrerConfig {
    /// Referrer identifier.
    referrerId: uint256
    /// Referrer fee in basis points.
    feeBps: uint16
}

/// DeDust Uranus token sell request emitted by the wallet.
struct (0xb7459e2c) DedustX1000UranusSell {
    /// Caller-selected correlation identifier.
    queryId: uint64
    /// Token quantity sold in base units.
    amount: coins
    /// Minimum accepted GRAM output in nanograms.
    minGramOut: coins
    /// Optional recipient of excess GRAM.
    excessAddress: address?
    /// Optional partner attribution.
    partner: Cell<DedustX1000UranusPartnerConfig>?
    /// Optional referrer attribution.
    referrer: Cell<DedustX1000UranusReferrerConfig>?
}

/// TEP-74 Jetton burn request emitted by the wallet.
struct (0x595f07bc) DedustX1000JettonBurn {
    /// Caller-selected correlation identifier.
    queryId: uint64
    /// Jetton quantity burned in token base units.
    amount: coins
    /// Optional recipient of excess GRAM.
    responseDestination: address?
    /// Optional application payload stored by reference.
    customPayload: cell?
}

/// Protocol payloads constructed by wallet route builders.
type DedustX1000WalletV2ProtocolPayload =
    | DedustX1000DedustSwapPayload
    | DedustX1000StonfiV2SwapPayload
    | DedustX1000ToncoSwapPayload
    | DedustX1000CpmmPayJettonPayload
    | DedustX1000CpmmSwapPayload
    | DedustX1000BidaskDammSwapPayload
    | DedustX1000BidaskClmmSwapPayload
    | DedustX1000CoffeeSwapPayload
    | DedustX1000MoonSwapPayload
    | DedustX1000MoonSwapSucceeded
    | DedustX1000MoonSwapFailed
    | DedustX1000MoonClmmSwapPayload
    | DedustX1000PayloadFa45056b
    | DedustX1000StonfiV1SwapPayload

/// Application-defined outbound event `0x10937847`.
struct (0x10937847) DedustX1000WalletV2Event10937847 {
    /// Application-defined 64-bit value.
    unknown0: uint64
    /// Application-defined 32-bit value.
    unknown1: uint32
}

/// Application-defined outbound event `0xbeaf9617`.
struct (0xbeaf9617) DedustX1000WalletV2EventBeaf9617 {
    /// Application-defined 64-bit value.
    unknown0: uint64
}

/// Internal message bodies emitted by the wallet.
type DedustX1000WalletV2OutgoingMessage =
    | DedustX1000WalletV2ExecutionRequested
    | DedustX1000WalletV2JettonTransfer
    | DedustX1000StonksPumpSell
    | DedustX1000UranusSell
    | DedustX1000JettonBurn

/// External event bodies emitted by the wallet.
type DedustX1000WalletV2Event =
    | DedustX1000WalletV2Event10937847
    | DedustX1000WalletV2EventBeaf9617

/// Wallet-specific exit codes.
enum DedustX1000WalletV2Errors {
    /// Signed-request sequence check failed.
    InvalidSeqno = 102
    /// Referenced pending operation was not found.
    PendingOperationNotFound = 103
    /// Stored layout revision is not supported by this implementation.
    UnsupportedStorageVersion = 104
    /// Authorization or request validation failed.
    AuthorizationOrRequestValidationFailed = 555
}

/// Sequence number expected in the next accepted signed request.
get fun seqno(): int {
    throw 0;
}

/// Synthetic name for getter method id 83648; returns the current balance in nanograms.
get fun get_method_83648_69107(): int {
    throw 0;
}

/// Synthetic name for getter method id 85802; reports whether the first runtime dictionary is empty.
get fun get_method_85802_4977(): bool {
    throw 0;
}

/// Synthetic name for getter method id 89828; returns the action-configuration cell hash.
get fun get_method_89828_151680(): int {
    throw 0;
}

/// Synthetic name for getter method id 91459; returns the stored sequence number.
get fun get_method_91459_1072(): int {
    throw 0;
}

/// Synthetic name for getter method id 94056; reports whether the third runtime dictionary is empty.
get fun get_method_94056_66388(): bool {
    throw 0;
}

/// Storage layout revision.
get fun storage_version(): int {
    throw 0;
}

/// Synthetic name for getter method id 97027; returns the application-defined counter.
get fun get_method_97027_232299(): int {
    throw 0;
}

/// Synthetic name for getter method id 97376; returns `0` for a known 64-bit runtime key and `1` otherwise.
get fun get_method_97376_77788(key: int): int {
    throw 0;
}

/// Synthetic name for getter method id 98121; reports whether the second runtime dictionary is empty.
get fun get_method_98121_79196(): bool {
    throw 0;
}

/// Synthetic name for getter method id 118999; reports whether the first runtime dictionary is empty.
get fun get_method_118999_18140(): bool {
    throw 0;
}
