/// MarketApp Rent v2r2 NFT rental interface.
contract MarketAppNftRentalV2R2Revision1 {
    author: "MarketApp"
    version: "2.2"
    description: "MarketApp Rent v2r2 listing and derived-rental contract with signed rent, extension, completion, cancellation, and direct-sale flows."
    storage: MarketAppNftRentalV2R2Revision1Storage
    incomingMessages: MarketAppNftRentalV2R2Revision1IncomingMessage
    incomingExternal: MarketAppNftRentalV2R2Revision1IncomingExternalMessage
    outgoingMessages: MarketAppNftRentalV2R2Revision1OutgoingMessage
    thrownErrors: Errors
}

/// Persistent root shared by original listings and their derived active-rental contracts.
struct MarketAppNftRentalV2R2Revision1Storage {
    /// Referenced immutable identity and role parameters.
    identity: Cell<MarketAppNftRentalV2R2Revision1Identity>
    /// Referenced rental lifecycle state.
    state: Cell<MarketAppNftRentalV2R2Revision1State>
    /// Referenced owner-configured rental and direct-sale terms.
    rentSettings: Cell<MarketAppNftRentalV2R2Revision1RentSettings>
    /// Referenced MarketApp fee parameters.
    feeSettings: Cell<MarketAppNftRentalV2R2Revision1FeeSettings>
    /// Ed25519 public key that verifies signed rent, extension, and operator requests.
    publicKey: uint256
}

/// Identity fields copied into a derived rental contract at deployment.
struct MarketAppNftRentalV2R2Revision1Identity {
    /// Listing owner that configures terms and receives rental or sale proceeds.
    ownerAddress: address
    /// NFT item controlled by this rental contract.
    nftAddress: address
    /// MarketApp operator authorized to relay raw messages outside lifecycle states zero and one.
    marketplaceAddress: address
    /// Unix timestamp when this contract instance was created.
    createdAt: uint64
    /// Contract role: zero for the original listing and one for a derived rental instance.
    role: uint2
}

/// Mutable rental lifecycle data.
struct MarketAppNftRentalV2R2Revision1State {
    /// Lifecycle tag used by the listing and derived-rental state machine.
    status: uint3
    /// Rental duration in seconds retained for the current or most recent rental.
    rentalDuration: uint32
    /// Unix expiry timestamp retained for the current or most recent rental.
    rentalUntil: uint64
    /// Daily price in nanograms retained for the current or most recent rental.
    pricePerDay: coins
    /// Renter retained for the current or most recent rental, or `addr_none` when absent.
    renterAddress: address?
    /// Linked original or derived rental contract, or `addr_none` when absent.
    counterpartRentalAddress: address?
}

/// Owner-configured rent, discount, and direct-sale terms.
struct MarketAppNftRentalV2R2Revision1RentSettings {
    /// Whether the NFT is relisted after a rental ends.
    autoRelist: bool
    /// Minimum accepted rental duration in seconds.
    minDuration: uint32
    /// Maximum accepted rental duration in seconds.
    maxDuration: uint32
    /// Required daily rental price in nanograms.
    pricePerDay: coins
    /// Discount-rate numerator applied for each additional rental day.
    discountPerDay: uint32
    /// Denominator used to convert the accumulated discount rate into an amount.
    discountDenominator: uint32
    /// Maximum accumulated discount-rate numerator.
    maxDiscount: uint32
    /// Direct-sale price in nanograms; zero disables purchases.
    salePrice: coins
}

/// Market fee recipient and fractional rate.
struct MarketAppNftRentalV2R2Revision1FeeSettings {
    /// Account that receives the MarketApp fee.
    recipientAddress: address
    /// Fee-rate numerator.
    numerator: uint32
    /// Fee-rate denominator.
    denominator: uint32
}

/// Optional referral fee request appended to signed rent and extension bodies.
struct MarketAppNftRentalV2R2Revision1Referral {
    /// Account that receives the referral share.
    recipientAddress: address
    /// Referral-rate numerator applied to the MarketApp fee.
    numerator: uint32
    /// Referral-rate denominator.
    denominator: uint32
    /// Remaining body bits and references forwarded with the referral payment.
    payload: RemainingBitsAndRefs
}

/// Empty marker accepted when a derived rental contract is deployed.
struct (0x12d10a32) MarketAppNftRentalV2R2Revision1DeployMarker {}

/// Empty marker intentionally ignored by the contract.
struct (0x664c0905) MarketAppNftRentalV2R2Revision1IgnoredMarker {}

/// Text command body; only the exact UTF-8 strings `cancel` and `complete` are dispatched.
struct (0x00000000) MarketAppNftRentalV2R2Revision1TextCommand {
    /// UTF-8 command bytes stored directly after the zero opcode.
    text: RemainingBitsAndRefs
}

/// Market-operator command that forwards an arbitrary complete message.
struct (0x0000022b) MarketAppNftRentalV2R2Revision1AdminRelay {
    /// Referenced raw-message command.
    command: Cell<MarketAppNftRentalV2R2Revision1AdminRelayCommand>
}

/// Referenced TVM raw-message command.
struct MarketAppNftRentalV2R2Revision1AdminRelayCommand {
    /// TVM send mode; values containing flag 32 are rejected.
    sendMode: uint8
    /// Complete outbound message passed to `send_raw_message`.
    message: cell
}

/// Complete an expired rental and return or forward the NFT.
struct (0x3cba3012) MarketAppNftRentalV2R2Revision1Complete {}

/// Synchronize the current rental settings into a linked rental contract.
struct (0xd577d80a) MarketAppNftRentalV2R2Revision1SyncRentSettings {
    /// Referenced replacement settings copied into persistent state.
    rentSettings: Cell<MarketAppNftRentalV2R2Revision1RentSettings>
}

/// Owner request that disables automatic relisting after a rental ends.
struct (0x6ae50714) MarketAppNftRentalV2R2Revision1DisableAutoRelist {}

/// Owner request that changes only the automatic-relisting flag.
struct (0x7122785a) MarketAppNftRentalV2R2Revision1SetAutoRelist {
    /// New automatic-relisting flag.
    autoRelist: bool
}

/// Owner request that replaces all rental, discount, and direct-sale settings.
struct (0x023cd52c) MarketAppNftRentalV2R2Revision1UpdateRentSettings {
    /// Whether the NFT is relisted after a rental ends.
    autoRelist: bool
    /// Minimum accepted rental duration in seconds.
    minDuration: uint32
    /// Maximum accepted rental duration in seconds.
    maxDuration: uint32
    /// Required daily rental price in nanograms.
    pricePerDay: coins
    /// Discount-rate numerator per additional rental day.
    discountPerDay: uint32
    /// Denominator used to calculate the discount amount.
    discountDenominator: uint32
    /// Maximum accumulated discount-rate numerator.
    maxDiscount: uint32
    /// Direct-sale price in nanograms; zero disables purchases.
    salePrice: coins
}

/// Cancel an available listing and transfer the NFT back to its owner.
struct (0xcc0f2526) MarketAppNftRentalV2R2Revision1Cancel {}

/// Signed request that rents an NFT under the current terms.
struct (0xedcdab69) MarketAppNftRentalV2R2Revision1Rent {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Daily price that must equal the current configured price.
    pricePerDay: coins
    /// Requested rental duration in seconds.
    duration: uint32
    /// Public key installed in the derived rental contract.
    renterPublicKey: uint256
    /// Optional referenced referral fee parameters.
    referral: Cell<MarketAppNftRentalV2R2Revision1Referral>?
}

/// Signed request that extends an active rental.
struct (0xc8f8109e) MarketAppNftRentalV2R2Revision1ExtendRent {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Daily price that must equal the current configured price.
    pricePerDay: coins
    /// Additional rental duration in seconds.
    extensionDuration: uint32
    /// Optional referenced referral fee parameters.
    referral: Cell<MarketAppNftRentalV2R2Revision1Referral>?
}

/// Purchase the NFT for the configured direct-sale price.
struct (0xbfd77a5a) MarketAppNftRentalV2R2Revision1Buy {}

/// Empty external request that completes an expired rental.
struct (0x3cba3012) MarketAppNftRentalV2R2Revision1CompleteExternal {}

/// Signed external request that disables automatic relisting.
struct (0x6ae50714) MarketAppNftRentalV2R2Revision1DisableAutoRelistExternal {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Unix timestamp accepted only within the contract's replay window.
    timestamp: uint64
}

/// TEP-62 NFT transfer emitted to the controlled item.
struct (0x5fcc3d14) MarketAppNftRentalV2R2Revision1NftTransfer {
    /// Flow-specific query id selected by the contract.
    queryId: uint64
    /// New NFT owner or linked rental contract.
    newOwnerAddress: address
    /// Optional destination for an NFT transfer response.
    responseDestination: address?
    /// Optional custom payload; this contract emits no custom payload.
    customPayload: cell?
    /// Nanograms forwarded to the new owner; this contract emits zero.
    forwardTonAmount: coins
    /// Raw TEP-62 `Either Cell ^Cell` forward payload tail.
    forwardPayload: RemainingBitsAndRefs
}

/// Text notification or fee label emitted with a zero opcode.
struct (0x00000000) MarketAppNftRentalV2R2Revision1TextNotification {
    /// UTF-8 notification text stored after the zero opcode.
    text: RemainingBitsAndRefs
}

/// Internal message bodies accepted by this rental revision.
type MarketAppNftRentalV2R2Revision1IncomingMessage =
    | MarketAppNftRentalV2R2Revision1DeployMarker
    | MarketAppNftRentalV2R2Revision1IgnoredMarker
    | MarketAppNftRentalV2R2Revision1TextCommand
    | MarketAppNftRentalV2R2Revision1AdminRelay
    | MarketAppNftRentalV2R2Revision1Complete
    | MarketAppNftRentalV2R2Revision1SyncRentSettings
    | MarketAppNftRentalV2R2Revision1DisableAutoRelist
    | MarketAppNftRentalV2R2Revision1SetAutoRelist
    | MarketAppNftRentalV2R2Revision1UpdateRentSettings
    | MarketAppNftRentalV2R2Revision1Cancel
    | MarketAppNftRentalV2R2Revision1Rent
    | MarketAppNftRentalV2R2Revision1ExtendRent
    | MarketAppNftRentalV2R2Revision1Buy

/// External-in bodies accepted by this rental revision.
type MarketAppNftRentalV2R2Revision1IncomingExternalMessage =
    | MarketAppNftRentalV2R2Revision1CompleteExternal
    | MarketAppNftRentalV2R2Revision1DisableAutoRelistExternal

/// Structured outbound bodies emitted by this rental revision.
type MarketAppNftRentalV2R2Revision1OutgoingMessage =
    | MarketAppNftRentalV2R2Revision1DeployMarker
    | MarketAppNftRentalV2R2Revision1SyncRentSettings
    | MarketAppNftRentalV2R2Revision1NftTransfer
    | MarketAppNftRentalV2R2Revision1TextNotification

/// Rental validation and authorization exit codes.
enum Errors {
    /// Ed25519 signature verification failed.
    InvalidSignature = 403
    /// Market relay send mode contains the forbidden destroy-account flag.
    InvalidRelaySendMode = 400
    /// The operation is not valid in the current lifecycle state.
    InvalidState = 1001
    /// The sender is not authorized for the requested operation.
    UnauthorizedSender = 1002
    /// Attached message value is insufficient for rent, fees, and execution.
    InsufficientMessageValue = 1003
    /// Rental completion was requested before the expiry timestamp.
    RentalNotExpired = 1004
    /// Rental extension was requested after the expiry timestamp.
    RentalExpired = 1005
    /// Rental duration or resulting duration is outside configured limits.
    InvalidDuration = 1006
    /// Signed external timestamp is outside the accepted replay window.
    InvalidTimestamp = 1007
    /// Daily rental price is non-positive or does not match configured terms.
    InvalidPrice = 1008
    /// Operation is incompatible with this original/derived contract role.
    InvalidContractRole = 1009
    /// Fee or discount calculation produced no owner proceeds.
    InvalidNetAmount = 1010
    /// Direct sale is disabled by a zero configured price.
    BuyDisabled = 1011
    /// Empty external completion body unexpectedly contains references.
    UnexpectedExternalReferences = 4004
    /// Empty external completion body unexpectedly contains trailing bits.
    UnexpectedExternalBits = 4005
    /// Incoming message opcode is unsupported.
    UnsupportedOperation = 65535
}

/// Return the Ed25519 key used to authenticate signed offers and admin requests.
get fun get_public_key(): uint256 {
    throw 0;
}
