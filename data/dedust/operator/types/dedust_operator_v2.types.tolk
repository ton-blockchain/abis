/// DeDust protocol v2 Operator: role-bound relay deployed by the Factory that forwards admin commands to pools and vaults.
contract DedustOperatorV2 {
    author: "DeDust"
    version: "2.0"
    description: "DeDust Operator is a role-bound relay deployed by the Factory; its user forwards arbitrary bodies through it so pools and vaults see the operator as the sender."
    incomingMessages: DedustOperatorV2IncomingMessage
    outgoingMessages: DedustOperatorV2OutgoingMessage
    forceAbiExport: DedustOperatorV2ForwardedCommand
}

/// Command from the operator's user: the body is forwarded verbatim to the destination.
struct (0xf1989255) DedustOperatorV2Forward {
    /// Query id of the command.
    queryId: uint64
    /// Contract that receives the forwarded body.
    destination: address
    /// Body forwarded as-is.
    body: cell
}

/// Factory command replacing the user allowed to forward through the operator.
struct (0x48e5a95d) DedustOperatorV2SetUserAddress {
    /// Query id of the command.
    queryId: uint64
    /// New user address.
    userAddress: address
}

/// Internal message bodies accepted by the operator.
type DedustOperatorV2IncomingMessage =
    | DedustOperatorV2Forward
    | DedustOperatorV2SetUserAddress

/// Fee collection forwarded to a pool.
struct (0x0b429f52) DedustOperatorV2CollectFees {
    /// Query id copied from the forward.
    queryId: uint64
    /// Amount of the first asset to withdraw.
    asset0Amount: coins
    /// Recipient of the first asset.
    asset0Destination: address
    /// Optional payload attached to the first payout.
    asset0Payload: cell?
    /// Amount of the second asset to withdraw.
    asset1Amount: coins
    /// Recipient of the second asset.
    asset1Destination: address?
    /// Optional payload attached to the second payout.
    asset1Payload: cell?
}

/// Trading start time forwarded to a pool.
struct (0x7ed7f6ce) DedustOperatorV2ConfigureStartTime {
    /// Query id copied from the forward.
    queryId: uint64
    /// Unix time after which swaps are accepted.
    startAt: uint32
}

/// Bodies commonly wrapped into a forward.
type DedustOperatorV2ForwardedCommand =
    | DedustOperatorV2CollectFees
    | DedustOperatorV2ConfigureStartTime

/// Internal message bodies emitted by the operator; the forwarded body itself is application-defined.
type DedustOperatorV2OutgoingMessage =
    | DedustOperatorV2CollectFees
    | DedustOperatorV2ConfigureStartTime
