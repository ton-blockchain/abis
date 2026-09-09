/// Error codes are identical to w5 for common failures.
enum Errors {
    BeginParseOfNull = 7
    InvalidSeqno = 133
    InvalidSubwalletId = 134
    InvalidSignature = 135
    Expired = 136
    ExternalSendMessageMustHaveIgnoreErrorsSendMode = 137
    InvalidOutArrayLen = 147
    NewKeyMustDiffer = 148
    NewKeySignatureIsInvalid = 149
    InvalidOpcode = 0xFFFF
}
