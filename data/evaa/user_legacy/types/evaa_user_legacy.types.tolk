/// EVAA user position contract before the combined supply-withdraw flow: message surface of the standalone withdraw operation.
contract EvaaUserLegacy {
    author: "EVAA"
    version: "7"
    description: "EVAA User Legacy is a per-account lending position running user code up to version 7, which still serves the standalone withdraw flow of the masters."
    incomingMessages: EvaaUserLegacyIncomingMessage
    outgoingMessages: EvaaUserLegacyOutgoingMessage
    forceAbiExport: EvaaUserLegacyCommand
}

/// Two-bit boolean used by EVAA headers.
type EvaaUserLegacyBoolExtended = int2

/// Optional code and data pushed by the master during a user upgrade.
struct EvaaUserLegacyUpgradeInfo {
    /// New user code.
    newCode: cell
    /// New user data.
    newData: cell
}

/// Upgrade header prepended by the master to every command.
struct EvaaUserLegacyUpgradeHeader {
    /// User code version the master expects.
    userCodeVersion: coins
    /// Optional upgrade pushed together with the command.
    upgradeInfo: Cell<EvaaUserLegacyUpgradeInfo>?
    /// Whether the upgrade is executed before the command.
    upgradeExec: EvaaUserLegacyBoolExtended
}

/// Referenced part of a withdraw command.
struct EvaaUserLegacyWithdrawUserExtra {
    /// Asset configuration dictionary keyed by 256-bit asset id.
    assetConfigCollection: cell?
    /// Asset dynamics dictionary keyed by 256-bit asset id.
    assetDynamicsCollection: cell?
    /// Packed oracle prices.
    pricesPacked: cell?
    /// GRAM forwarded with the withdrawn asset.
    forwardTonAmount: uint64
    /// Payload returned to the owner.
    customResponsePayload: cell
}

/// Withdraw command sent from the master to the user contract.
struct (0x00000021) EvaaUserLegacyWithdrawUser {
    /// Query id copied into the reply.
    queryId: uint64
    /// Asset id being withdrawn.
    assetId: uint256
    /// Requested amount in the asset's current units.
    withdrawAmountCurrent: uint64
    /// Supply rate at the time of the request.
    sRate: uint64
    /// Borrow rate at the time of the request.
    bRate: uint64
    /// Recipient of the withdrawn asset.
    recipientAddress: address
    /// Referenced prices, configuration and payload.
    extra: Cell<EvaaUserLegacyWithdrawUserExtra>
}

/// Successful withdraw confirmation sent from the master to the user contract.
struct (0x0000211a) EvaaUserLegacyWithdrawSuccess {
    /// Query id copied from the withdraw.
    queryId: uint64
    /// Asset id that was withdrawn.
    assetId: uint256
    /// Signed principal delta applied to the position.
    principalAmount: int64
    /// Supply reward tracking index.
    trackingSupplyIndex: uint64
    /// Borrow reward tracking index.
    trackingBorrowIndex: uint64
}

/// Withdraw failure sent from the master to the user contract.
struct (0x0000211f) EvaaUserLegacyWithdrawFail {
    /// Query id copied from the withdraw.
    queryId: uint64
    /// Asset id that was requested.
    assetId: uint256
    /// Signed principal delta to revert.
    principalAmount: int64
}

/// Commands parsed after the upgrade header.
type EvaaUserLegacyCommand =
    | EvaaUserLegacyWithdrawUser
    | EvaaUserLegacyWithdrawSuccess
    | EvaaUserLegacyWithdrawFail

/// Upgrade header followed by the command.
@overflow1023_policy("suppress")
struct EvaaUserLegacyPackedCommand {
    /// Upgrade header.
    upgradeHeader: EvaaUserLegacyUpgradeHeader
    /// Command.
    command: EvaaUserLegacyCommand
}

/// Internal message body accepted by the user contract.
type EvaaUserLegacyIncomingMessage = EvaaUserLegacyPackedCommand

/// Referenced part of a collateralized withdraw reply.
struct EvaaUserLegacyWithdrawCollateralizedExtra {
    /// Recipient of the withdrawn asset.
    recipientAddress: address
    /// GRAM forwarded with the withdrawn asset.
    forwardTonAmount: uint64
    /// Payload returned to the owner.
    customResponsePayload: cell
}

/// Collateral check passed; sent from the user contract to the master.
struct (0x00000211) EvaaUserLegacyWithdrawCollateralized {
    /// Query id copied from the withdraw.
    queryId: uint64
    /// Position owner.
    ownerAddress: address
    /// Asset id being withdrawn.
    assetId: uint256
    /// Requested amount in the asset's current units.
    withdrawAmountCurrent: uint64
    /// Principal after the withdraw.
    userNewPrincipal: int64
    /// Principal part borrowed by the withdraw.
    borrowAmountPrincipal: int64
    /// Principal part reclaimed from supply by the withdraw.
    reclaimAmountPrincipal: int64
    /// Referenced recipient and payload.
    extra: Cell<EvaaUserLegacyWithdrawCollateralizedExtra>
}

/// Excess returned to the owner when the position is locked.
struct (0x000021e6) EvaaUserLegacyWithdrawLockedExcess {
    /// Query id copied from the withdraw.
    queryId: uint64
}

/// Excess returned to the owner when the position is not collateralized enough.
struct (0x000021e7) EvaaUserLegacyWithdrawNotCollateralizedExcess {
    /// Query id copied from the withdraw.
    queryId: uint64
}

/// Excess returned to the owner when the master lacks funds.
struct (0x00211fe8) EvaaUserLegacyWithdrawNoFundsExcess {
    /// Query id copied from the withdraw.
    queryId: uint64
}

/// Excess returned to the owner when oracle prices are missing.
struct (0x000021e8) EvaaUserLegacyWithdrawMissingPricesExcess {
    /// Query id copied from the withdraw.
    queryId: uint64
}

/// Excess returned to the owner when the withdraw execution crashed.
struct (0x000021ec) EvaaUserLegacyWithdrawExecutionCrashed {
    /// Query id copied from the withdraw.
    queryId: uint64
}

/// Text comment `EVAA withdraw.` sent to the owner with the successful withdraw excess.
struct (0x00000000) EvaaUserLegacyWithdrawExcessText {
    /// Comment text.
    text: RemainingBitsAndRefs
}

/// Internal message bodies emitted by the user contract in the withdraw flow.
type EvaaUserLegacyOutgoingMessage =
    | EvaaUserLegacyWithdrawCollateralized
    | EvaaUserLegacyWithdrawLockedExcess
    | EvaaUserLegacyWithdrawNotCollateralizedExcess
    | EvaaUserLegacyWithdrawNoFundsExcess
    | EvaaUserLegacyWithdrawMissingPricesExcess
    | EvaaUserLegacyWithdrawExecutionCrashed
    | EvaaUserLegacyWithdrawExcessText
