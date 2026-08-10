/// ForTON executor that validates authorization and constructs an FRT/GRAM STON.fi swap.
contract FrtGramSwapExecutor {
    author: "ForTON"
    description: "Validates receiver-specific route authorization and executes FRT/GRAM swaps through STON.fi."
    storage: FrtGramSwapExecutorStorage
    storageAtDeployment: FrtGramSwapExecutorDeploymentStorage
    incomingMessages: FrtGramSwapExecutorIncomingMessage
    outgoingMessages: FrtGramSwapExecutorOutgoingMessage
    forceAbiExport: FrtGramSwapExecutorEmptyBody | FrtGramSwapExecutorStonfiV2SwapPayload
    thrownErrors: Errors
}

/// Runtime configuration of the persistent swap executor.
struct FrtGramSwapExecutorStorage {
    /// True after executor configuration has been initialized.
    initialized: bool
    /// Primary controller allowed to change configuration and withdraw GRAM.
    primaryController: address
    /// Secondary controller allowed to rotate selected configuration fields.
    secondaryController: address
    /// Root value required by receiver-specific route authorization records.
    authorizationRoot: uint256
    /// True when new swap requests are paused.
    paused: bool
}

/// Initial executor state before authorization and pause configuration is appended.
struct FrtGramSwapExecutorDeploymentStorage {
    /// False in the deployment state.
    initialized: bool
    /// Primary controller address.
    primaryController: address
    /// Secondary controller address.
    secondaryController: address
}

/// Request that authorizes and routes an FRT/GRAM swap through STON.fi.
struct (0xe84d6ac5) ForTonFrtSwapRequest {
    /// Address receiving swap output, refunds, and excess value.
    receiver: address
    /// Referenced authorization record containing receiver limits and validity bounds.
    routeAuthorization: cell
}

/// Controller request to replace the authorization root used for swap validation.
struct (0x39fe3991) FrtGramSwapExecutorSetAuthorizationRoot {
    /// New 256-bit authorization root.
    authorizationRoot: uint256
}

/// Controller request to pause or resume new swaps.
struct (0x011138ea) FrtGramSwapExecutorSetPaused {
    /// True to reject new swap requests; false to accept them.
    paused: bool
}

/// Controller request to replace the secondary controller.
struct (0xc76dd369) FrtGramSwapExecutorSetSecondaryController {
    /// New secondary controller address.
    secondaryController: address
}

/// Primary-controller request to transfer primary control.
struct (0x0f474d03) FrtGramSwapExecutorSetPrimaryController {
    /// New primary controller address.
    primaryController: address
}

/// Primary-controller request to send an exact amount of GRAM.
struct (0x457c3243) FrtGramSwapExecutorWithdrawGram {
    /// Address receiving the withdrawal.
    destination: address
    /// GRAM amount transferred to the destination, in nanoGRAM.
    amount: coins
}

/// Primary-controller request to send the balance above the 0.1 GRAM reserve.
struct (0x0393b1ce) FrtGramSwapExecutorDrainGram {
    /// Address receiving the available balance.
    destination: address
}

/// Empty body used for no-op receipts and value-only replies or withdrawals.
struct FrtGramSwapExecutorEmptyBody {}

/// STON.fi pTON request carrying the swap as its forward payload.
struct (0x01f3835d) FrtGramSwapExecutorPtonTonTransfer {
    /// Query id used by the executor; currently zero.
    queryId: uint64
    /// Native GRAM amount tokenized for the swap.
    tonAmount: coins
    /// Address receiving a pTON refund if tokenization fails.
    refundAddress: address
    /// TEP-161 `Either Cell ^Cell` tail carrying a referenced STON.fi V2 swap payload.
    forwardPayload: RemainingBitsAndRefs
}

/// Referenced STON.fi V2 swap limits and notification configuration.
struct FrtGramSwapExecutorStonfiV2SwapBody {
    /// Minimum accepted FRT output in token base units.
    minOut: coins
    /// Final address receiving swapped FRT.
    receiver: address?
    /// GRAM amount forwarded with a successful swap notification, in nanoGRAM.
    forwardGas: coins
    /// Optional success notification payload.
    customPayload: cell?
    /// GRAM amount forwarded with a refund notification, in nanoGRAM.
    refundForwardGas: coins
    /// Optional refund notification payload.
    refundPayload: cell?
    /// Referral fee in STON.fi fee units.
    referralFee: uint16
    /// Optional referral address.
    referralAddress: address?
}

/// STON.fi V2 swap payload referenced by the outgoing pTON transfer.
struct (0x6664de2a) FrtGramSwapExecutorStonfiV2SwapPayload {
    /// Router-owned wallet for the FRT output asset.
    tokenWallet: address
    /// Address receiving refunded assets.
    refundAddress: address
    /// Address receiving excess GRAM.
    excessesAddress: address
    /// Unix timestamp after which the swap is no longer valid.
    deadline: uint64
    /// Swap limits and notification parameters stored by reference.
    swapBody: Cell<FrtGramSwapExecutorStonfiV2SwapBody>
}

/// Internal message bodies accepted by the persistent executor.
type FrtGramSwapExecutorIncomingMessage =
    | ForTonFrtSwapRequest
    | FrtGramSwapExecutorSetAuthorizationRoot
    | FrtGramSwapExecutorSetPaused
    | FrtGramSwapExecutorSetSecondaryController
    | FrtGramSwapExecutorSetPrimaryController
    | FrtGramSwapExecutorWithdrawGram
    | FrtGramSwapExecutorDrainGram

/// Internal message bodies emitted by the persistent executor.
type FrtGramSwapExecutorOutgoingMessage = FrtGramSwapExecutorPtonTonTransfer

/// VM exit codes raised while validating routes or controller operations.
enum Errors {
    /// Message body does not match a supported operation or empty settlement body.
    UnsupportedOperation = 130
    /// Receiver-specific relay address derivation failed.
    InvalidRelayAddress = 128
    /// Authorization record is absent or not a valid extended cell.
    MissingAuthorizationRecord = 103
    /// Authorization record version is not version 3.
    InvalidAuthorizationVersion = 104
    /// Authorization record root differs from executor storage.
    AuthorizationRootMismatch = 105
    /// Receiver is not present in the authorization dictionary.
    ReceiverNotAuthorized = 109
    /// Authorization validity interval has not started.
    AuthorizationNotYetValid = 10647
    /// Authorization validity interval has expired.
    AuthorizationExpired = 37321
    /// Sender is not an allowed controller or the receiver's deterministic relay.
    UnauthorizedSender = 4429
    /// New swap requests are paused.
    SwapsPaused = 19792
    /// Exact withdrawal would consume the required 0.1 GRAM reserve.
    InsufficientWithdrawableBalance = 54615
    /// Only the primary controller may drain the available balance.
    DrainRequiresPrimaryController = 9215
}

/// Return the deterministic relay address for a receiver and authorization root.
get fun get_method_123059_enem(receiver: address, authorizationRoot: uint256): any_address {
    throw 0;
}

/// Return whether new swap requests are paused.
get fun isPaused(): bool {
    throw 0;
}

/// Return the configured route authorization root.
get fun get_method_126756_emdl(): uint256 {
    throw 0;
}
