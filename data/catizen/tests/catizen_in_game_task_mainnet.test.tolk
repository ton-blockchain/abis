import "@acton/build"
import "@acton/io"
import "@acton/emulation/network"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/catizen_in_game_task.types"
import "../wrappers/CatizenInGameTask.gen"

const CODE_PATH = "data/catizen/testdata/CatizenInGameTask.boc"
const DATA_PATH = "data/catizen/testdata/CatizenInGameTask.data.boc"
const CODE_HASH = 0x4c5c7db2619ba345f987c0be2387bf0e9904caa3fe04d2f22db730cfcb6c077e
const DATA_HASH = 0x2bf4652afb0fc3114376674578ecd19a1b73e48bc4093b4eae484cdc6c3479f7
const CONTRACT_ADDRESS = "EQChB2eMoFG4ThuEsZ6ehlBPKJXOjNxlR5B7qKZNGIv256Da"
const OWNER_ADDRESS = "EQCo79ZR7NuhxhaDpIh796c8P_riWlecPY_kw4bLax1vzZ0T"
const TASK_COUNT = 20177922
const ACCOUNT_BALANCE = 62458569

struct LoadedCatizenInGameTaskStorage {
    data: cell
    storage: CatizenInGameTaskStorage
}

fun catizenInGameTask(): CatizenInGameTask {
    return CatizenInGameTask.fromAddress(address(CONTRACT_ADDRESS));
}

fun loadCatizenInGameTaskStorage(contract: CatizenInGameTask): LoadedCatizenInGameTaskStorage {
    val account = testing.getAccountState(contract.address);
    expect(account).toBeNotNull();

    match (account!.storage.state) {
        TlbAccountStateActive => {
            val code = account!.storage.state.stateInit.code;
            val data = account!.storage.state.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(CODE_HASH);
            expect(code!.hash()).toEqual(build("CatizenInGameTask", CODE_PATH).hash());
            expect(data!.hash()).toEqual(DATA_HASH);
            expect(data!.hash()).toEqual(build("CatizenInGameTaskData", DATA_PATH).hash());
            return LoadedCatizenInGameTaskStorage {
                data: data!,
                storage: CatizenInGameTaskStorage.fromCell(data!),
            };
        }
        TlbAccountStateUninit => {
            Assert.fail("Catizen In-Game Task is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("Catizen In-Game Task is frozen at the pinned block");
        }
    }
}

get fun `test Catizen in-game task pinned storage and getters`() {
    val contract = catizenInGameTask();
    val loaded = loadCatizenInGameTaskStorage(contract);
    val storage = loaded.storage;

    expect(scripts.isContractDeployed(contract.address)).toBeTrue();
    expect(storage.toCell().hash()).toEqual(loaded.data.hash());
    expect(storage.initialized).toBeTrue();
    expect(storage.taskCount).toEqual(TASK_COUNT);
    expect(storage.owner).toEqual(address(OWNER_ADDRESS));

    expect(contract.owner().castToInternal()).toEqual(storage.owner);
    expect(contract.balance()).toEqual(ACCOUNT_BALANCE);
    expect(contract.getMethod107884Blzd()).toEqual(storage.taskCount);

    val interfaces = contract.supportedInterfaces();
    expect(interfaces.ipfsAbi).toEqual(0x5cec3d5d2cae7b1e84ec39d64a851b66);
    expect(interfaces.lazyDeployment).toEqual(0x9dd6352d2b647cb322d3af2dfdf16239);
    expect(interfaces.tactContract).toEqual(0x2055c01b80676394ce583aae4725b2c3);
    expect(interfaces.unknownApplication0).toEqual(0x9d974e5ab34ecb733a0e966d9466e8a4);
    expect(interfaces.unknownApplication1).toEqual(0xf2e77fabe685e82ce45aad0abb05b14a);
    expect(interfaces.ownable).toEqual(0x40ce7569e715f9d250b01d616e2647b2);

    val deploymentStatus = contract.lazyDeploymentCompleted();
    expect(deploymentStatus.completed).toBeTrue();
    expect(deploymentStatus.remainingStorage.remainingBitsCount()).toEqual(524);
    expect(deploymentStatus.remainingStorage.remainingRefsCount()).toEqual(1);

    val abiUri = contract.getAbiIpfs();
    expect(abiUri.remainingBitsCount()).toEqual(424);
    expect(abiUri.remainingRefsCount()).toEqual(0);

    println("CATIZEN_IN_GAME_TASK_STORAGE={}", storage);
}

get fun `test Catizen in-game task accepts a task record`() {
    val contract = catizenInGameTask();
    val sender = testing.treasury("catizen-in-game-task-record");
    val taskCountBefore = contract.getMethod107884Blzd();

    val txs = contract.sendCatizenInGameTaskRecord(
        sender.address,
        beginCell().storeUint(0x43415449, 32).endCell(),
        { value: ton("0.008"), bounce: false },
    );

    expect(txs).toHaveSuccessfulTx<CatizenInGameTaskRecord>({
        from: sender.address,
        to: contract.address,
        exitCode: 0,
    });
    expect(contract.getMethod107884Blzd()).toEqual(taskCountBefore + 1);
}

get fun `test Catizen in-game task rejects an unauthorized owner withdrawal`() {
    val contract = catizenInGameTask();
    val sender = testing.treasury("catizen-in-game-task-unauthorized-withdrawal");

    val txs = contract.sendCatizenOwnerGramWithdrawal(
        sender.address,
        1,
        { value: ton("0.05"), bounce: false },
    );

    expect(txs).toHaveFailedTx<CatizenOwnerGramWithdrawal>({
        from: sender.address,
        to: contract.address,
        exitCode: CatizenInGameTaskErrors.UnauthorizedSender,
    });
}

get fun `test Catizen in-game task rejects an underfunded text comment`() {
    val contract = catizenInGameTask();
    val sender = testing.treasury("catizen-in-game-task-underfunded-comment");

    val txs = contract.sendCatizenTextComment(
        sender.address,
        createEmptyCell().beginParse(),
        { value: ton("0.001"), bounce: false },
    );

    expect(txs).toHaveFailedTx<CatizenTextComment>({
        from: sender.address,
        to: contract.address,
        exitCode: CatizenInGameTaskErrors.InsufficientCommentValue,
    });
}
