/// Current storage schema of the contract.
/// A new contract revision bumps its 0xXX prefix and may append new fields.
/// See `runMigrationAndUpdateC4` about migrations after bytecode upgrade.
struct (0x00) Storage {
    /// Seqno protects against replay attacks: every incoming message contains the expected seqno.
    /// Once the contract accepts a message, it bumps storage seqno. Old messages can't be replayed.
    seqno: uint32
    /// SubwalletId allows creating multiple wallets for one private key.
    /// Default for mainnet: 0x7FFF7F11; for testnet: 0x7FFF7FFD; for subwallets, consider docs.
    subwalletId: uint32
    /// Public key used to check signatures of all incoming messages.
    /// It can be replaced by a signed change-key request.
    publicKey: uint256
}
