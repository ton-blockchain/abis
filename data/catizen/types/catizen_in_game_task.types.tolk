/// Catizen contract that records in-game tasks and supports owner withdrawals.
contract CatizenInGameTask {
    author: "Catizen"
    version: "1.0"
    description: "Catizen In-Game Task contract for task records, ownership, and balance withdrawals."
    storage: CatizenInGameTaskStorage
    storageAtDeployment: CatizenInGameTaskDeploymentStorage
    incomingMessages: CatizenInGameTaskIncomingMessage
    outgoingMessages: CatizenInGameTaskOutgoingMessage
    forceAbiExport: CatizenInGameTaskEmptyBody
    thrownErrors: CatizenInGameTaskErrors
}

/// Persistent root retained before the first lazy-deployment message initializes the contract.
struct CatizenInGameTaskDeploymentStorage {
    /// Referenced Tact deployment context and contract-system data.
    deploymentContext: cell
    /// False until runtime storage has been initialized.
    initialized: bool
    /// Internal address retained before initialization.
    /// Runtime ownership is set from the first sender.
    initialAddress: address
}

/// Persistent runtime state of the initialized in-game task contract.
struct CatizenInGameTaskStorage {
    /// Referenced Tact deployment context and contract-system data.
    deploymentContext: cell
    /// True after lazy deployment has initialized runtime state.
    initialized: bool
    /// Number of task records processed by the two application handlers.
    taskCount: int257
    /// Internal address authorized to withdraw funds and transfer ownership.
    owner: address
}

/// Record one referenced application payload and increment the stored task counter.
struct (0x61153514) CatizenInGameTaskRecord {
    /// Referenced payload inferred to contain task data; its internal format is not inspected on-chain.
    taskData: cell
}

/// Record the alternate application payload format with an inline signed value.
struct (0x6dec2375) CatizenInGameTaskRecordWithValue {
    /// Inferred application value parsed as a signed integer but otherwise unused by this revision.
    applicationValue: int257
    /// Referenced payload inferred to contain task data and returned as a text-comment cell chain.
    taskData: cell
}

/// Withdraw a requested amount of GRAM to the stored owner.
struct (0x12f69c8a) CatizenOwnerGramWithdrawal {
    /// GRAM amount transferred to the owner, in nanoGRAM.
    amount: int257
}

/// Ask the contract to transfer Jettons from a supplied Jetton wallet to its owner.
struct (0x41349d30) CatizenOwnerJettonWithdrawal {
    /// Jetton amount passed to the emitted transfer message, in token base units.
    jettonAmount: coins
    /// Additional coin value parsed but not used by this deployed revision.
    unusedAmount: coins
    /// Jetton wallet that receives the emitted transfer request.
    jettonWallet: address
}

/// Standard Tact lazy-deployment request.
struct (0x946a98b6) CatizenDeploy {
    /// Caller-selected identifier echoed by the deployment acknowledgement.
    queryId: uint64
}

/// Standard Tact ownership-transfer request accepted only from the current owner.
struct (0x819dbe99) CatizenChangeOwner {
    /// Caller-selected identifier echoed by the ownership acknowledgement.
    queryId: uint64
    /// Internal address installed as the new owner.
    newOwner: address
}

/// Text-comment transfer accepted when it carries at least 0.002 GRAM.
struct (0x00000000) CatizenTextComment {
    /// Remaining comment bytes and continuation references ignored by the contract.
    text: RemainingBitsAndRefs
}

/// Internal message bodies handled explicitly by the Catizen In-Game Task contract.
type CatizenInGameTaskIncomingMessage =
    | CatizenInGameTaskRecord
    | CatizenInGameTaskRecordWithValue
    | CatizenOwnerGramWithdrawal
    | CatizenOwnerJettonWithdrawal
    | CatizenDeploy
    | CatizenChangeOwner
    | CatizenTextComment

/// Empty internal body emitted by an owner GRAM withdrawal.
struct CatizenInGameTaskEmptyBody {}

/// Text-comment acknowledgement or application text returned to a task-record sender.
struct (0x00000000) CatizenTextCommentResponse {
    /// Empty acknowledgement text or an application-defined echoed cell chain.
    text: RemainingBitsAndRefs
}

/// Standard Jetton transfer emitted for an owner Jetton withdrawal.
struct (0x0f8a7ea5) CatizenJettonTransfer {
    /// Current Unix timestamp widened to 64 bits by the contract.
    queryId: uint64
    /// Jetton amount transferred to the stored owner, in token base units.
    amount: coins
    /// Stored owner that receives the Jettons.
    destination: address
    /// Stored owner that receives transfer responses and excess value.
    responseDestination: address
    /// Present referenced cell retained as an opaque custom payload.
    customPayload: cell?
    /// GRAM forwarded with the Jetton transfer notification, in nanoGRAM.
    forwardTonAmount: coins
    /// Raw inline tail containing a 32-bit Unix timestamp followed by 32 zero bits.
    forwardPayload: RemainingBitsAndRefs
}

/// Standard Tact acknowledgement emitted after lazy deployment.
struct (0xaff90f57) CatizenDeployOk {
    /// Query identifier copied from the deployment request.
    queryId: uint64
}

/// Standard Tact acknowledgement emitted after ownership changes.
struct (0x327b2b4a) CatizenChangeOwnerOk {
    /// Query identifier copied from the ownership request.
    queryId: uint64
    /// Newly installed owner address.
    newOwner: address
}

/// Body-bearing internal messages emitted by the Catizen In-Game Task contract.
type CatizenInGameTaskOutgoingMessage =
    | CatizenTextCommentResponse
    | CatizenJettonTransfer
    | CatizenDeployOk
    | CatizenChangeOwnerOk

/// Interface identifiers returned by the Tact-generated introspection getter.
struct CatizenSupportedInterfaces {
    /// Tact IPFS-ABI interface identifier.
    ipfsAbi: int
    /// Tact lazy-deployment interface identifier.
    lazyDeployment: int
    /// Tact base-contract interface identifier.
    tactContract: int
    /// First unidentified application-specific interface identifier.
    unknownApplication0: int
    /// Second unidentified application-specific interface identifier.
    unknownApplication1: int
    /// Tact ownership interface identifier.
    ownable: int
}

/// Raw status returned by the generated lazy-deployment getter.
struct CatizenLazyDeploymentStatus {
    /// Storage slice remaining after the initialization flag is read.
    remainingStorage: slice
    /// True when runtime storage has been initialized.
    completed: bool
}

/// Returns the current contract owner.
get fun owner(): any_address {
    throw 0;
}

/// Returns the account balance in nanoGRAM.
get fun balance(): int {
    throw 0;
}

/// Returns the number of processed task records.
get fun get_method_107884_blzd(): int {
    throw 0;
}

/// Returns the six interface identifiers advertised by the contract.
get fun supported_interfaces(): CatizenSupportedInterfaces {
    throw 0;
}

/// Returns the remaining storage slice and lazy-deployment completion flag.
get fun lazy_deployment_completed(): CatizenLazyDeploymentStatus {
    throw 0;
}

/// Returns the IPFS URI of the original Tact ABI.
get fun get_abi_ipfs(): slice {
    throw 0;
}

/// Exit codes reachable while dispatching and validating internal messages.
enum CatizenInGameTaskErrors {
    /// Incoming body does not match a supported message format.
    InvalidIncomingMessage = 130
    /// Sender is not the stored owner for a protected operation.
    UnauthorizedSender = 132
    /// Address has an invalid serialized length or internal-address form.
    InvalidAddress = 136
    /// Address belongs to an unsupported workchain or address class.
    UnsupportedAddress = 137
    /// Text-comment transfer carries less than the required 0.002 GRAM.
    InsufficientCommentValue = 28444
}
