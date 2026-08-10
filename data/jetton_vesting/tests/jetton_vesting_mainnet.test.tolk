import "@acton/build"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/jetton_vesting.types"
import "../wrappers/JettonVesting.gen"

const EXPECTED_CODE_HASH = 0xb360d6da4bb86554459ca38c3ec6f26e932370743eacf1219cad54ee006b5ca6
const CODE_BOC_PATH = "data/jetton_vesting/testdata/JettonVesting.boc"
const MAINNET_ADDRESS = "EQAFpr-4AamlDrWSYyLuHf0Ndv3EKMXpYSrT42YZYfGXpSA_"

get fun `test jetton vesting mainnet code and storage match tracked revision`() {
    val vesting = JettonVesting.fromAddress(address(MAINNET_ADDRESS));
    val account = testing.getAccountState(vesting.address);
    expect(account).toBeNotNull();

    val accountState = account!.storage.state;
    match (accountState) {
        TlbAccountStateActive => {
            val code = accountState.stateInit.code;
            val data = accountState.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(EXPECTED_CODE_HASH);
            expect(code!.hash()).toEqual(build("JettonVesting", CODE_BOC_PATH).hash());
            val storage = JettonVestingStorage.fromCell(data!);
            expect(storage.toCell().hash()).toEqual(data!.hash());
            expect(storage.isInitialized).toBeTrue();
            expect(storage.ownerAddress).toEqual(
                address("0:1805213800D6B95E8620629A62B3EBACC50AF25C769768E373A9B7011B385D91"),
            );
            expect(storage.jettonWalletAddress).toEqual(
                address("0:70CA268E43324A54E727F3B9F4D3D5EEEAC91D7F2767963409AD5D22B07857A9"),
            );
            expect(storage.vestingDurationYears).toBeGreater(0);
            expect(storage.remainingJettonAmount).toBeGreater(0);
            val allocation = storage.allocationState.load();
            expect(allocation.totalJettonAmount).toBeGreaterOrEqual(storage.remainingJettonAmount);
        }
        TlbAccountStateUninit => {
            Assert.fail("Jetton Vesting mainnet account is uninitialized");
        }
        TlbAccountStateFrozen => {
            Assert.fail("Jetton Vesting mainnet account is frozen");
        }
    }
}
