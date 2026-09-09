/// Every time the contract logic is updated,
/// we append a new revision and provide a new storage migration.
/// Read `MIGRATION.md`.
enum Revision: uint8 {
    Rev00_Initial = 0
}

const LAST_REVISION = Revision.Rev00_Initial
