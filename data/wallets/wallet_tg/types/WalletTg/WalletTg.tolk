import "errors"
import "messages"
import "revisions"
import "storage"

/// WalletTg, the Telegram Wallet contract, is a wallet whose bytecode is stored in config.
/// Its blockchain logic is shared by all Telegram users and atomically updated by validator voting.
contract WalletTg {
    author: "TON Core"
    version: "1.0"
    description: "Telegram wallet contract; bytecode stays in config and is updated by validator voting"
    storage: Storage
    incomingMessages: SignedRequest<AllowedInternalMsg>
    incomingExternal: SignedRequest<AllowedExternalMsg>
    thrownErrors: Errors
}

type AllowedInternalMsg =
    | SendOneMessageRequestI
    | SendBulkMessagesRequestI
    | ChangePublicKeyRequestI

type AllowedExternalMsg =
    | SendOneMessageRequestE
    | SendBulkMessagesRequestE
    | ChangePublicKeyRequestE

/// Returns current storage revision. It does not trigger migration.
/// After bytecode upgrade, returns the old revision until the first valid incoming message migrates `c4`.
get fun revision(): Revision {
    throw 0;
}

/// Returns current seqno from the storage. Bumped on every valid incoming message.
get fun seqno(): uint32 {
    throw 0;
}

/// Returns the subwallet id from the storage.
get fun get_subwallet_id(): uint32 {
    throw 0;
}

/// Returns the public key corresponding to the signer's private key.
get fun get_public_key(): uint256 {
    throw 0;
}
