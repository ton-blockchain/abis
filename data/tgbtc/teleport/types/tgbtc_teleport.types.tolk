/// TON Teleport BTC bridge contract: mints tgBTC for confirmed Bitcoin deposits and emits pegout events for burns and key rotations.
contract TgbtcTeleport {
    author: "RSquad"
    version: "1.0"
    description: "tgBTC Teleport verifies Bitcoin deposits, mints tgBTC to the depositor, and emits mint, burn and new-key events consumed by the bridge oracles."
    emittedEvents: TgbtcTeleportEvent
}

/// Emitted after a Bitcoin deposit is verified and tgBTC is minted.
struct (0x77a80ef3) TgbtcTeleportMintEvent {
    /// Minted amount in satoshi.
    amount: coins
    /// Account that received the minted tgBTC.
    recipientAddress: address
    /// Bitcoin transaction id of the deposit.
    bitcoinTxid: uint256
}

/// Emitted after tgBTC is burned and a Bitcoin pegout is requested.
struct (0xca444ce6) TgbtcTeleportBurnEvent {
    /// Burned amount in satoshi.
    amount: coins
    /// Account that sent the burn; empty for bridge-initiated pegouts.
    senderAddress: address?
    /// Pegout transaction contract deployed for the withdrawal.
    pegoutAddress: address?
}

/// Emitted when the coordinator delivers a new internal key and the bridge UTXOs move to the new address.
struct (0x27756729) TgbtcTeleportNewKeyEvent {
    /// Amount in satoshi transferred to the new bridge address.
    amount: coins
    /// X coordinate of the new internal public key.
    newInternalPubkey: uint256
    /// Pegout transaction contract deployed for the transfer; empty when nothing is moved.
    pegoutAddress: address?
}

/// External event bodies emitted by the teleport.
type TgbtcTeleportEvent =
    | TgbtcTeleportMintEvent
    | TgbtcTeleportBurnEvent
    | TgbtcTeleportNewKeyEvent
