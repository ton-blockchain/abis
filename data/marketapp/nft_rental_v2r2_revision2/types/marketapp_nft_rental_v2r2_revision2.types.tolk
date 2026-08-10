/// MarketApp Rent v2r2 NFT rental interface with structured state, terms, and fee getters.
contract MarketAppNftRentalV2R2Revision2 {
    author: "MarketApp"
    version: "2.2"
    description: "MarketApp Rent v2r2 listing and derived-rental contract with signed rent, extension, completion, cancellation, and direct-sale flows."
    storage: MarketAppNftRentalV2R2Revision2Storage
    incomingMessages: MarketAppNftRentalV2R2Revision2IncomingMessage
    incomingExternal: MarketAppNftRentalV2R2Revision2IncomingExternalMessage
    outgoingMessages: MarketAppNftRentalV2R2Revision2OutgoingMessage
    thrownErrors: Errors
}

/// Persistent root shared by original listings and their derived active-rental contracts.
struct MarketAppNftRentalV2R2Revision2Storage {
    /// Referenced immutable identity and role parameters.
    identity: Cell<MarketAppNftRentalV2R2Revision2Identity>
    /// Referenced rental lifecycle state.
    state: Cell<MarketAppNftRentalV2R2Revision2State>
    /// Referenced owner-configured rental and direct-sale terms.
    rentSettings: Cell<MarketAppNftRentalV2R2Revision2RentSettings>
    /// Referenced MarketApp fee parameters.
    feeSettings: Cell<MarketAppNftRentalV2R2Revision2FeeSettings>
    /// Ed25519 public key that verifies signed rent, extension, and operator requests.
    publicKey: uint256
}

/// Identity fields copied into a derived rental contract at deployment.
struct MarketAppNftRentalV2R2Revision2Identity {
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
struct MarketAppNftRentalV2R2Revision2State {
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
struct MarketAppNftRentalV2R2Revision2RentSettings {
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
struct MarketAppNftRentalV2R2Revision2FeeSettings {
    /// Account that receives the MarketApp fee.
    recipientAddress: address
    /// Fee-rate numerator.
    numerator: uint32
    /// Fee-rate denominator.
    denominator: uint32
}

/// Optional referral fee request appended to signed rent and extension bodies.
struct MarketAppNftRentalV2R2Revision2Referral {
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
struct (0x12d10a32) MarketAppNftRentalV2R2Revision2DeployMarker {}

/// Empty marker intentionally ignored by the contract.
struct (0x664c0905) MarketAppNftRentalV2R2Revision2IgnoredMarker {}

/// Text command body; only the exact UTF-8 strings `cancel` and `complete` are dispatched.
struct (0x00000000) MarketAppNftRentalV2R2Revision2TextCommand {
    /// UTF-8 command bytes stored directly after the zero opcode.
    text: RemainingBitsAndRefs
}

/// Market-operator command that forwards an arbitrary complete message.
struct (0x0000022b) MarketAppNftRentalV2R2Revision2AdminRelay {
    /// Referenced raw-message command.
    command: Cell<MarketAppNftRentalV2R2Revision2AdminRelayCommand>
}

/// Referenced TVM raw-message command.
struct MarketAppNftRentalV2R2Revision2AdminRelayCommand {
    /// TVM send mode; values containing flag 32 are rejected.
    sendMode: uint8
    /// Complete outbound message passed to `send_raw_message`.
    message: cell
}

/// Complete an expired rental and return or forward the NFT.
struct (0x3cba3012) MarketAppNftRentalV2R2Revision2Complete {}

/// Synchronize the current rental settings into a linked rental contract.
struct (0xd577d80a) MarketAppNftRentalV2R2Revision2SyncRentSettings {
    /// Referenced replacement settings copied into persistent state.
    rentSettings: Cell<MarketAppNftRentalV2R2Revision2RentSettings>
}

/// Owner request that disables automatic relisting after a rental ends.
struct (0x6ae50714) MarketAppNftRentalV2R2Revision2DisableAutoRelist {}

/// Owner request that changes only the automatic-relisting flag.
struct (0x7122785a) MarketAppNftRentalV2R2Revision2SetAutoRelist {
    /// New automatic-relisting flag.
    autoRelist: bool
}

/// Owner request that replaces all rental, discount, and direct-sale settings.
struct (0x023cd52c) MarketAppNftRentalV2R2Revision2UpdateRentSettings {
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
struct (0xcc0f2526) MarketAppNftRentalV2R2Revision2Cancel {}

/// Signed request that rents an NFT under the current terms.
struct (0xedcdab69) MarketAppNftRentalV2R2Revision2Rent {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Daily price that must equal the current configured price.
    pricePerDay: coins
    /// Requested rental duration in seconds.
    duration: uint32
    /// Public key installed in the derived rental contract.
    renterPublicKey: uint256
    /// Optional referenced referral fee parameters.
    referral: Cell<MarketAppNftRentalV2R2Revision2Referral>?
}

/// Signed request that extends an active rental.
struct (0xc8f8109e) MarketAppNftRentalV2R2Revision2ExtendRent {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Daily price that must equal the current configured price.
    pricePerDay: coins
    /// Additional rental duration in seconds.
    extensionDuration: uint32
    /// Optional referenced referral fee parameters.
    referral: Cell<MarketAppNftRentalV2R2Revision2Referral>?
}

/// Purchase the NFT for the configured direct-sale price.
struct (0xbfd77a5a) MarketAppNftRentalV2R2Revision2Buy {}

/// Empty external request that completes an expired rental.
struct (0x3cba3012) MarketAppNftRentalV2R2Revision2CompleteExternal {}

/// Signed external request that disables automatic relisting.
struct (0x6ae50714) MarketAppNftRentalV2R2Revision2DisableAutoRelistExternal {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Unix timestamp accepted only within the contract's replay window.
    timestamp: uint64
}

/// Signed external request that cancels an available listing.
struct (0xcc0f2526) MarketAppNftRentalV2R2Revision2CancelExternal {
    /// Ed25519 signature checked against the stored public key.
    signature: bits512
    /// Unix timestamp accepted only within the contract's replay window.
    timestamp: uint64
}

/// TEP-62 NFT transfer emitted to the controlled item.
struct (0x5fcc3d14) MarketAppNftRentalV2R2Revision2NftTransfer {
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
struct (0x00000000) MarketAppNftRentalV2R2Revision2TextNotification {
    /// UTF-8 notification text stored after the zero opcode.
    text: RemainingBitsAndRefs
}

/// Internal message bodies accepted by this rental revision.
type MarketAppNftRentalV2R2Revision2IncomingMessage =
    | MarketAppNftRentalV2R2Revision2DeployMarker
    | MarketAppNftRentalV2R2Revision2IgnoredMarker
    | MarketAppNftRentalV2R2Revision2TextCommand
    | MarketAppNftRentalV2R2Revision2AdminRelay
    | MarketAppNftRentalV2R2Revision2Complete
    | MarketAppNftRentalV2R2Revision2SyncRentSettings
    | MarketAppNftRentalV2R2Revision2DisableAutoRelist
    | MarketAppNftRentalV2R2Revision2SetAutoRelist
    | MarketAppNftRentalV2R2Revision2UpdateRentSettings
    | MarketAppNftRentalV2R2Revision2Cancel
    | MarketAppNftRentalV2R2Revision2Rent
    | MarketAppNftRentalV2R2Revision2ExtendRent
    | MarketAppNftRentalV2R2Revision2Buy

/// External-in bodies accepted by this rental revision.
type MarketAppNftRentalV2R2Revision2IncomingExternalMessage =
    | MarketAppNftRentalV2R2Revision2CompleteExternal
    | MarketAppNftRentalV2R2Revision2DisableAutoRelistExternal
    | MarketAppNftRentalV2R2Revision2CancelExternal

/// Structured outbound bodies emitted by this rental revision.
type MarketAppNftRentalV2R2Revision2OutgoingMessage =
    | MarketAppNftRentalV2R2Revision2DeployMarker
    | MarketAppNftRentalV2R2Revision2SyncRentSettings
    | MarketAppNftRentalV2R2Revision2NftTransfer
    | MarketAppNftRentalV2R2Revision2TextNotification

/// Market fee tuple returned by `get_fees`.
struct MarketAppNftRentalV2R2Revision2Fees {
    /// Account that receives the MarketApp fee.
    recipientAddress: any_address
    /// Fee-rate numerator.
    numerator: uint32
    /// Fee-rate denominator.
    denominator: uint32
}

/// Rental lifecycle tuple returned by `get_state`.
struct MarketAppNftRentalV2R2Revision2StateResult {
    /// Lifecycle tag used by the listing and derived-rental state machine.
    status: uint3
    /// Rental duration in seconds retained for the current or most recent rental.
    rentalDuration: uint32
    /// Unix expiry timestamp retained for the current or most recent rental.
    rentalUntil: uint64
    /// Daily price in nanograms retained for the current or most recent rental.
    pricePerDay: coins
    /// Renter retained for the current or most recent rental, or `addr_none` when absent.
    renterAddress: any_address
    /// Linked original or derived rental contract, or `addr_none` when absent.
    counterpartRentalAddress: any_address
}

/// Rental and direct-sale terms returned by `get_config`.
struct MarketAppNftRentalV2R2Revision2Config {
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

/// Listing identity and role tuple.
struct MarketAppNftRentalV2R2Revision2IdentityResult {
    /// Listing owner that configures terms and receives rental or sale proceeds.
    ownerAddress: any_address
    /// NFT item controlled by this rental contract.
    nftAddress: any_address
    /// MarketApp operator authorized to relay raw messages outside lifecycle states zero and one.
    marketplaceAddress: any_address
    /// Unix timestamp when this contract instance was created.
    createdAt: uint64
    /// Contract role: zero for the original listing and one for a derived rental instance.
    role: uint2
}

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
    /// Discount parameters do not form a valid bounded fraction.
    InvalidDiscountConfiguration = 1012
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

/// Return the MarketApp fee recipient and fractional rate.
get fun get_fees(): MarketAppNftRentalV2R2Revision2Fees {
    throw 0;
}

/// Return the current rental lifecycle state.
get fun get_state(): MarketAppNftRentalV2R2Revision2StateResult {
    throw 0;
}

/// Return the current rental, discount, and direct-sale terms.
get fun get_config(): MarketAppNftRentalV2R2Revision2Config {
    throw 0;
}

/// Synthetic name for getter method id 124409; returns listing identity and role fields.
get fun get_method_124409_63178(): MarketAppNftRentalV2R2Revision2IdentityResult {
    throw 0;
}
