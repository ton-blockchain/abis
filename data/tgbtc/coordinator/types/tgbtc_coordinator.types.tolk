/// TON Teleport BTC coordinator: runs the oracle DKG rounds on the masterchain and announces the resulting bridge key.
contract TgbtcCoordinator {
    author: "RSquad"
    version: "1.0"
    description: "tgBTC Coordinator collects the distributed key generation rounds of the bridge oracles and emits the resulting internal public key."
    emittedEvents: TgbtcCoordinatorEvent
}

/// Emitted when a distributed key generation round completes.
struct (0x453443a6) TgbtcCoordinatorDkgCompletedEvent {
    /// Unix time the key generation completed.
    timestamp: uint64
    /// X coordinate of the generated internal public key.
    internalPubkey: uint256
}

/// External event bodies emitted by the coordinator.
type TgbtcCoordinatorEvent = TgbtcCoordinatorDkgCompletedEvent
