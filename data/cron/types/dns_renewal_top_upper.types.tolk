/// Wallet V5 DNS auto-renewal top-upper: builds the cron contract that keeps a wallet's `.ton` domains renewed and funds it.
contract DnsRenewalTopUpper {
    author: "1IxI1"
    version: "1.0"
    description: "DNS Renewal Top-Upper receives a schedule from a Wallet V5 owner, derives the cron contract that will call the wallet's renewal extension, and forwards the attached value to it."
    incomingMessages: DnsRenewalTopUpperIncomingMessage
    outgoingMessages: DnsRenewalTopUpperOutgoingMessage
    forceAbiExport: DnsRenewalTopUpperExtensionActionRequest
        | DnsRenewalTopUpperOutActionWithSendMessageOnly
}

/// Schedule description; the same body is re-sent to the top-upper by the cron contract on every trigger.
struct (0x56f6110e) DnsRenewalTopUpperCalcAndTopup {
    /// Unix time of the first cron call.
    firstCallTime: uint32
    /// Interval in seconds between cron calls.
    repeatEvery: uint32
    /// Salt copied into the cron contract data.
    salt: uint32
    /// Reward the cron contract pays per trigger.
    reward: coins
    /// Wallet V5 that owns the domains and the cron contract.
    ownerAddress: address
    /// Prepared out-action list with the renewal messages, extended with the self top-up.
    renewalActionsCell: cell
    /// Value the cron contract sends back to the top-upper on every trigger.
    topupAmount: coins
    /// Value the cron contract attaches to the wallet extension request.
    msgToWalletAmount: coins
}

/// Internal message bodies accepted by the top-upper.
type DnsRenewalTopUpperIncomingMessage = DnsRenewalTopUpperCalcAndTopup

/// Text body sent to the derived cron contract together with the top-up value.
struct (0x00000000) DnsRenewalTopUpperTopUpText {
    /// The literal `topup`.
    text: RemainingBitsAndRefs
}

/// Internal message bodies emitted by the top-upper.
type DnsRenewalTopUpperOutgoingMessage = DnsRenewalTopUpperTopUpText

/// Wallet V5 extension action request stored inside the cron contract and sent to the wallet on every trigger.
struct (0x6578746e) DnsRenewalTopUpperExtensionActionRequest {
    /// Query id, always zero.
    queryId: uint64
    /// Out-action list executed by the wallet.
    outActions: cell?
    /// Whether extended actions follow; always false.
    hasExtraActions: bool
}

/// Out-action list node with a single send-message action.
struct (0x0ec3c86d) DnsRenewalTopUpperOutActionWithSendMessageOnly {
    /// Previous action list node.
    prev: cell
    /// Send mode of the message.
    sendMode: uint8
    /// Full message to send.
    outMsg: cell
}
