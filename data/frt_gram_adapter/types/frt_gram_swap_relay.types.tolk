/// One-shot ForTON relay that validates and forwards an FRT/GRAM swap request.
contract FrtGramSwapRelay {
    author: "ForTON"
    description: "Validates an FRT/GRAM swap request and forwards it to the persistent executor."
    storage: FrtGramSwapRelayStorage
    storageAtDeployment: FrtGramSwapRelayDeploymentStorage
    incomingMessages: FrtGramSwapRelayIncomingMessage
    outgoingMessages: FrtGramSwapRelayOutgoingMessage
    forceAbiExport: FrtGramSwapRelayEmptyBody
    thrownErrors: Errors
}

/// Runtime state of a receiver-specific one-shot swap relay.
struct FrtGramSwapRelayStorage {
    /// True after the deployment state has been initialized.
    initialized: bool
    /// Address allowed to submit the request and receive returned value.
    receiver: address
    /// Persistent ForTON executor receiving the forwarded request.
    executor: address
    /// Authorization root copied into the deterministic relay state.
    authorizationRoot: uint256
    /// True after a request is forwarded; reset to false if that request bounces.
    processed: bool
}

/// Initial relay state before the runtime processed flag is appended.
struct FrtGramSwapRelayDeploymentStorage {
    /// False in the deterministic deployment state.
    initialized: bool
    /// Address allowed to submit the request and receive returned value.
    receiver: address
    /// Persistent ForTON executor receiving the forwarded request.
    executor: address
    /// Authorization root copied from the executor configuration.
    authorizationRoot: uint256
}

/// Request that authorizes and routes an FRT/GRAM swap through STON.fi.
struct (0xe84d6ac5) ForTonFrtSwapRequest {
    /// Address receiving swap output, refunds, and excess value.
    receiver: address
    /// Referenced route authorization checked before the swap is constructed.
    routeAuthorization: cell
}

/// Empty settlement body used to return the relay's remaining GRAM.
struct FrtGramSwapRelayEmptyBody {}

/// Internal message bodies accepted by the one-shot relay.
type FrtGramSwapRelayIncomingMessage = ForTonFrtSwapRequest

/// Internal message bodies emitted by the one-shot relay.
type FrtGramSwapRelayOutgoingMessage = ForTonFrtSwapRequest

/// VM exit codes raised while validating or forwarding relay requests.
enum Errors {
    /// Message body is neither a swap request nor the supported empty settlement body.
    UnsupportedOperation = 130
    /// Attached value is below the 0.4 GRAM forwarding requirement.
    InsufficientValue = 9217
    /// Request sender differs from the receiver fixed in relay storage.
    UnauthorizedSender = 4429
    /// Receiver encoded in the request differs from relay storage.
    ReceiverMismatch = 55558
    /// A request was already forwarded and has not bounced.
    RequestAlreadyProcessed = 42504
}

/// Return whether this one-shot relay has forwarded a request that did not bounce.
get fun get_method_68602_obmz(): bool {
    throw 0;
}
