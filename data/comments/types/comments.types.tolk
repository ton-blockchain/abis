/// Payload-only ABI interface for text comment message bodies.
contract Comments {
    author: "TON"
    version: "1.0"
    description: "Text comments let wallets attach a human-readable note to a transfer, either in plain text or encrypted for the recipient's public key."
    incomingMessages: CommentsIncomingMessage
}

/// Plain UTF-8 comment stored as a snake string after the zero opcode.
struct (0x00000000) TextComment {
    /// Snake-encoded UTF-8 text.
    text: RemainingBitsAndRefs
}

/// Comment encrypted for the recipient; the cipher text is a snake string.
struct (0x2167da4b) EncryptedTextComment {
    /// Snake-encoded cipher text: sender public key XOR, nonce, salted and padded ciphertext.
    cipherText: RemainingBitsAndRefs
}

/// Comment bodies accepted by any account.
type CommentsIncomingMessage =
    | TextComment
    | EncryptedTextComment
