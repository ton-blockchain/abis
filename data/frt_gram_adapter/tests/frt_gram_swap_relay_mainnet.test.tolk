import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/frt_gram_swap_relay.types"
import "../wrappers/FrtGramSwapRelay.gen"

const RELAY_ADDRESS = "EQChjaWeFqRvvFhPIQ9GB6yfg4Wsr4TGCt73yiYEquIC-2k6"
const RELAY_CODE_HASH = 0x533695fd5bdbcb202f3b1143ec008b76043447b08a17448ed2479a7508ab8638
const RECEIVER = "EQDjTZritjDsup_dE1ni4bM_jGvqO3ijuLbzuTscqGAoJivA"
const EXECUTOR = "EQDNGuEuxoPuw6XafMT-HWJ0lDUHrITLty9hDYru2CKmt_2L"
const AUTHORIZATION_ROOT = 0x05177925fc1085cfd0d03cc48036e3b217e8bc60024e16ad58c0c4f15b9ca14c

get fun `test ForTON swap relay pinned storage and getter`() {
    val relay = FrtGramSwapRelay.fromAddress(address(RELAY_ADDRESS));
    val derivedRelay = FrtGramSwapRelay.fromStorage(
        FrtGramSwapRelayDeploymentStorage {
            initialized: false,
            receiver: address(RECEIVER),
            executor: address(EXECUTOR),
            authorizationRoot: AUTHORIZATION_ROOT,
        },
    );
    expect(derivedRelay.address).toEqual(relay.address);
    val account = testing.getAccountState(relay.address);
    expect(account).toBeNotNull();

    match (account!.storage.state) {
        TlbAccountStateActive => {
            val code = account!.storage.state.stateInit.code;
            val data = account!.storage.state.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(RELAY_CODE_HASH);

            val storage = FrtGramSwapRelayStorage.fromCell(data!);
            expect(storage.processed).toEqual(relay.getMethod68602Obmz());
            expect(storage.processed).toBeTrue();
        }
        TlbAccountStateUninit => {
            Assert.fail("ForTON swap relay is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("ForTON swap relay is frozen at the pinned block");
        }
    }
}
