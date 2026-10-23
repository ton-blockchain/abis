/// TON Cron reference contract: an owner-funded scheduler that lets any provider fire one stored message on time.
contract CronContract {
    author: "xssnick"
    version: "1.0"
    description: "TON Cron contract keeps one prepared message and pays a reward to whichever provider triggers it once the scheduled time has come."
    storage: CronContractStorage
    incomingMessages: CronContractIncomingMessage
    incomingExternal: CronContractIncomingExternalMessage
    outgoingMessages: CronContractOutgoingMessage
}

/// Persistent scheduler state.
struct CronContractStorage {
    /// Set by `cron_init` once the owner has activated the schedule.
    initialized: bool
    /// Unix time of the next allowed trigger.
    nextCallTime: uint32
    /// Interval in seconds added to the trigger time after each run.
    repeatEvery: uint32
    /// Deployer-chosen salt that makes the address unique.
    salt: uint32
    /// Reward paid to the provider that triggers the contract.
    reward: coins
    /// Owner allowed to initialize and destroy the schedule.
    ownerAddress: address
    /// Full internal message sent on every trigger.
    message: cell
    /// Hash of the data cell captured at initialization; zero before `cron_init`.
    initStateHash: uint256
    /// Depth of the data cell captured at initialization; zero before `cron_init`.
    initStateDepth: uint10
}

/// Owner request that activates the schedule and announces the contract to the discovery address.
struct (0x2e41d3ac) CronContractInit {}

/// Text command; `destroy` from the owner returns the balance, any other text with enough value re-announces the contract.
struct (0x00000000) CronContractTextCommand {
    /// Text after the zero opcode.
    text: RemainingBitsAndRefs
}

/// Internal message bodies accepted by the cron contract.
type CronContractIncomingMessage =
    | CronContractInit
    | CronContractTextCommand

/// Provider trigger sent as an external message once `nextCallTime` has passed.
struct (0x2114702d) CronContractTrigger {
    /// Basechain address that receives the reward.
    rewardAddress: address
    /// Provider-chosen value that makes repeated triggers distinct.
    salt: uint32
}

/// External message bodies accepted by the cron contract.
type CronContractIncomingExternalMessage = CronContractTrigger

/// Reward transfer sent to the triggering provider.
struct (0x2e04891a) CronContractReward {}

/// Announcement sent to the discovery address at initialization and on top-ups.
struct (0xd027efe5) CronContractNotify {
    /// Hash of the data cell captured at initialization.
    initStateHash: uint256
    /// Depth of the data cell captured at initialization.
    initStateDepth: uint10
}

/// Balance return sent to the owner when the schedule is destroyed.
struct (0xbbe27821) CronContractDestroyed {}

/// Internal message bodies emitted by the cron contract; the stored trigger message is application-defined.
type CronContractOutgoingMessage =
    | CronContractReward
    | CronContractNotify
    | CronContractDestroyed

/// Structured result returned by `get_cron_info`.
struct CronContractInfoReply {
    /// Unix time of the next allowed trigger.
    nextCallTime: int
    /// Reward paid to the triggering provider in nanograms.
    reward: int
    /// Balance minus the stored message value and the reward.
    availableBalance: int
    /// Interval in seconds between triggers.
    repeatEvery: int
}

/// Return the scheduling state.
get fun get_cron_info(): CronContractInfoReply {
    throw 0;
}
