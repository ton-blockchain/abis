import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/frt_gram_swap_executor.types"
import "../wrappers/FrtGramSwapExecutor.gen"

const EXECUTOR_ADDRESS = "EQDNGuEuxoPuw6XafMT-HWJ0lDUHrITLty9hDYru2CKmt_2L"
const EXECUTOR_CODE_HASH = 0xe46c2316b3543b5a64e87bf7ce1f430ec76b94b7e524f2e85b8737de25de643f
const RELAY_ADDRESS = "EQChjaWeFqRvvFhPIQ9GB6yfg4Wsr4TGCt73yiYEquIC-2k6"
const RECEIVER = "EQDjTZritjDsup_dE1ni4bM_jGvqO3ijuLbzuTscqGAoJivA"

get fun `test ForTON swap executor pinned storage and getters`() {
    val executor = FrtGramSwapExecutor.fromAddress(address(EXECUTOR_ADDRESS));
    val account = testing.getAccountState(executor.address);
    expect(account).toBeNotNull();

    match (account!.storage.state) {
        TlbAccountStateActive => {
            val code = account!.storage.state.stateInit.code;
            val data = account!.storage.state.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(EXECUTOR_CODE_HASH);

            val storage = FrtGramSwapExecutorStorage.fromCell(data!);
            expect(storage.paused).toEqual(executor.isPaused());
            expect(storage.authorizationRoot).toEqual(executor.getMethod126756Emdl());
            expect(
                executor
                    .getMethod123059Enem(address(RECEIVER), storage.authorizationRoot)
                    .castToInternal(),
            ).toEqual(address(RELAY_ADDRESS));
        }
        TlbAccountStateUninit => {
            Assert.fail("ForTON swap executor is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("ForTON swap executor is frozen at the pinned block");
        }
    }
}
