import "@acton/build"
import "@acton/fs"
import "@acton/io"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/dedust_x1000_wallet_v2.types"
import "../wrappers/DedustX1000WalletV2.gen"

const WALLET_ADDRESS = "EQAFixgyPnv8ejzC5jjobQmbAZxpe1Sbh_rKlk7FsnZPUFZn"
const FIXTURE_BOC_PATH = "data/dedust/x1000_wallet_v2/testdata/DedustX1000WalletV2.boc"
const EXPECTED_CODE_HASH = 0x4609b587ae70c1a4e65550377492cd8e13b4bcc8770d3e49b65aca90c26c56f2
const PINNED_MAINNET_BLOCK = 83536138

fun wallet(): DedustX1000WalletV2 {
    return DedustX1000WalletV2.fromAddress(address(WALLET_ADDRESS));
}

get fun `test DeDust x1000 Wallet V2 fixture has exact live code hash`() {
    val rawCodeBoc = fs.readBytes(FIXTURE_BOC_PATH);
    expect(rawCodeBoc).toBeNotNull();
    expect(build("DedustX1000WalletV2", FIXTURE_BOC_PATH).hash()).toEqual(
        EXPECTED_CODE_HASH,
    );
}

get fun `test DeDust x1000 Wallet V2 parses pinned storage and seqno`() {
    val contract = wallet();
    expect(scripts.isContractDeployed(contract.address)).toBeTrue();

    val account = testing.getAccountState(contract.address);
    expect(account).toBeNotNull();

    match (account!.storage.state) {
        TlbAccountStateActive => {
            val code = account!.storage.state.stateInit.code;
            val data = account!.storage.state.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(EXPECTED_CODE_HASH);
            expect(code!.hash()).toEqual(
                build("DedustX1000WalletV2", FIXTURE_BOC_PATH).hash(),
            );

            val storage = DedustX1000WalletV2Storage.fromCell(data!);
            val balance = contract.getMethod8364869107();
            val dictionary0Empty = contract.getMethod858024977();
            val implementationHash = contract.getMethod89828151680();
            val duplicateSeqno = contract.getMethod914591072();
            val dictionary2Empty = contract.getMethod9405666388();
            val storageVersion = contract.storageVersion();
            val counter0 = contract.getMethod97027232299();
            val existingKey = contract.getMethod9737677788(0);
            val dictionary1Empty = contract.getMethod9812179196();
            val duplicateDictionary0Empty = contract.getMethod11899918140();
            expect(storage.storageVersion).toEqual(1);
            expect(storage.seqno).toEqual(contract.seqno());
            expect(balance).toBeGreater(0);
            expect(implementationHash).toEqual(storage.implementationState.hash());
            expect(duplicateSeqno).toEqual(storage.seqno);
            expect(storageVersion).toEqual(storage.storageVersion);
            expect(counter0).toEqual(storage.counter0);
            expect(existingKey).toEqual(0);
            expect(duplicateDictionary0Empty).toEqual(dictionary0Empty);
            expect(storage.runtimeState.hash()).toBeGreater(0);
            expect(storage.implementationState.hash()).toBeGreater(0);
            println(
                "DEDUST_X1000_WALLET_V2_COUNTER0={} SEQNO={} DICTS_EMPTY={}/{}/{}",
                storage.counter0,
                storage.seqno,
                dictionary0Empty,
                dictionary1Empty,
                dictionary2Empty,
            );
        }
        TlbAccountStateUninit => {
            Assert.fail("DeDust x1000 Wallet V2 is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("DeDust x1000 Wallet V2 is frozen at the pinned block");
        }
    }
}
