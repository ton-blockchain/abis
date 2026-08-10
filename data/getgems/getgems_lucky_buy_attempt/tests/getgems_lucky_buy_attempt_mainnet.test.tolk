import "@acton/build"
import "@acton/io"
import "@acton/emulation/network"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/getgems_lucky_buy_attempt.types"
import "../wrappers/GetgemsLuckyBuyAttempt.gen"

const CONTRACT_ADDRESS = "EQBlQMPG12ktUZkXBudHs5TtFPySBkSk9VJcJjq_bWB2qVb-"
const CODE_PATH = "data/getgems/getgems_lucky_buy_attempt/testdata/GetgemsLuckyBuyAttempt.boc"
const CODE_HASH = 0x9785ed5ee1f07c1dedb5850eb6824d706f14769fec9a8a8a8462c3af1e10bd1d
const PINNED_MAINNET_BLOCK = 83536514

get fun `test Getgems Lucky Buy attempt parses pinned storage and getter`() {
    val contract = GetgemsLuckyBuyAttempt.fromAddress(address(CONTRACT_ADDRESS));
    expect(scripts.isContractDeployed(contract.address)).toBeTrue();

    val account = testing.getAccountState(contract.address);
    expect(account).toBeNotNull();
    match (account!.storage.state) {
        TlbAccountStateActive => {
            val code = account!.storage.state.stateInit.code;
            val data = account!.storage.state.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(CODE_HASH);
            expect(code!.hash()).toEqual(build("GetgemsLuckyBuyAttempt", CODE_PATH).hash());

            val storage = GetgemsLuckyBuyAttemptStorage.fromCell(data!);
            val config = storage.config.load();
            val result = contract.getMethod129613Xwm();
            expect(result.state).toEqual(storage.state);
            expect(result.fundedValue).toEqual(storage.fundedValue);
            expect(result.fundingAddress.castToInternal()).toEqual(storage.fundingAddress!);
            expect(result.fundedAt).toEqual(storage.fundedAt);
            expect(result.attemptId).toEqual(storage.attemptId);
            expect(result.decisionPublicKey).toEqual(config.decisionPublicKey);
            expect(result.participantAddress.castToInternal()).toEqual(config.participantAddress);
            expect(result.marketplaceAddress.castToInternal()).toEqual(config.marketplaceAddress);
            expect(result.requestNonce).toEqual(config.requestNonce);
            expect(result.nftItemAddress.hash()).toEqual(config.nftItemAddress.hash());
            println("GETGEMS_LUCKY_BUY_PINNED_MAINNET_BLOCK={}", PINNED_MAINNET_BLOCK);
        }
        TlbAccountStateUninit => {
            Assert.fail("Getgems Lucky Buy attempt is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("Getgems Lucky Buy attempt is frozen at the pinned block");
        }
    }
}

get fun `test Getgems Lucky Buy attempt recognizes marketplace relay prefix`() {
    val contract = GetgemsLuckyBuyAttempt.fromAddress(address(CONTRACT_ADDRESS));
    val sender = testing.treasury("getgems-lucky-buy-unauthorized-marketplace");
    val action = GetgemsLuckyBuyAttemptRawAction {
        sendMode: 0,
        message: createEmptyCell(),
    };

    val txs = contract.sendGetgemsLuckyBuyAttemptMarketplaceRelay(
        sender.address,
        action,
        { value: ton("0.05"), bounce: true },
    );

    expect(txs).toHaveFailedTx<GetgemsLuckyBuyAttemptMarketplaceRelay>({
        from: sender.address,
        to: contract.address,
        exitCode: GetgemsLuckyBuyAttemptErrors.UnauthorizedMarketplaceRelay,
    });
}
