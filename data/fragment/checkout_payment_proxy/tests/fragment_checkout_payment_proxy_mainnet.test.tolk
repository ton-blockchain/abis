import "@acton/build"
import "@acton/io"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/fragment_checkout_payment_proxy.types"
import "../wrappers/FragmentCheckoutPaymentProxy.gen"

const CONTRACT_ADDRESS = "EQBELNs-kCde5ynY1RBv3Dtui5rOnP2i00WjQroPoLMKZ8aM"
const CODE_PATH = "data/fragment/checkout_payment_proxy/testdata/FragmentCheckoutPaymentProxy.boc"
const CODE_HASH = 0xa7c2e6591f823692dcf4ccdb90a6d2ac83ec9b513a4e7076249e0a056f0aad32
const DATA_HASH = 0x96a296d224f285c67bee93c30f8a309157f0daa35dc5b87e410b78630a09cfc7
const PINNED_MAINNET_BLOCK = 83536223

get fun `test Fragment checkout payment proxy pinned code and empty storage`() {
    val contract = FragmentCheckoutPaymentProxy.fromAddress(address(CONTRACT_ADDRESS));
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
            expect(code!.hash()).toEqual(build("FragmentCheckoutPaymentProxy", CODE_PATH).hash());
            expect(data!.hash()).toEqual(DATA_HASH);
            expect(
                FragmentCheckoutPaymentProxyStorage.fromCell(data!).toCell().hash(),
            ).toEqual(DATA_HASH);
        }
        TlbAccountStateUninit => {
            Assert.fail("Fragment checkout payment proxy is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("Fragment checkout payment proxy is frozen at the pinned block");
        }
    }

    println("FRAGMENT_CHECKOUT_PAYMENT_PROXY_PINNED_MAINNET_BLOCK={}", PINNED_MAINNET_BLOCK);
}
