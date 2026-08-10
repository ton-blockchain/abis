import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/catizen_in_game_task.types"

const CODE_PATH = "data/catizen/testdata/CatizenInGameTask.boc"
const DATA_PATH = "data/catizen/testdata/CatizenInGameTask.data.boc"
const CODE_HASH = 0x4c5c7db2619ba345f987c0be2387bf0e9904caa3fe04d2f22db730cfcb6c077e
const DATA_HASH = 0x2bf4652afb0fc3114376674578ecd19a1b73e48bc4093b4eae484cdc6c3479f7
const TASK_DATA_HASH = 0x8cd8565592e7226d5f9797f38a0b82c352d8ad42121efdac3bdcde41fbb47b06
const OWNER_ADDRESS = "EQCo79ZR7NuhxhaDpIh796c8P_riWlecPY_kw4bLax1vzZ0T"
const TASK_COUNT = 20177922

get fun `test Catizen in-game task code data and real task record body`() {
    val codeBytes = fs.readBytes(CODE_PATH);
    val dataBytes = fs.readBytes(DATA_PATH);
    expect(codeBytes).toBeNotNull();
    expect(dataBytes).toBeNotNull();
    expect(codeBytes!.preloadUint(32)).toEqual(0xb5ee9c72);
    expect(dataBytes!.preloadUint(32)).toEqual(0xb5ee9c72);
    expect(build("CatizenInGameTask", CODE_PATH).hash()).toEqual(CODE_HASH);

    val data = build("CatizenInGameTaskData", DATA_PATH);
    expect(data.hash()).toEqual(DATA_HASH);
    val storage = CatizenInGameTaskStorage.fromCell(data);
    expect(storage.toCell().hash()).toEqual(DATA_HASH);
    expect(storage.initialized).toBeTrue();
    expect(storage.taskCount).toEqual(TASK_COUNT);
    expect(storage.owner).toEqual(address(OWNER_ADDRESS));

    // Mainnet transaction Air4Y3l7Y1L6VJ+4LGO6VXTSr3yz7Ma2jRL/XpqAfxQ=.
    val body = parseCellFromBase64("te6cckEBAgEAJwABCGEVNRQBADw5QU95RE52TFliSmFCOVhtS1hsNk1vN0dYcW1XUGtDl6jO");
    val decoded = CatizenInGameTaskRecord.fromCell(body);
    expect(decoded.taskData.hash()).toEqual(TASK_DATA_HASH);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test Catizen in-game task decodes real deployment body`() {
    // Mainnet transaction nsPFOrx1G+JRyTWF5BSXULf4d8ObBW4DFB14YVJgnrs=.
    val body = parseCellFromBase64("te6cckEBAQEADgAAGJRqmLYAAAAAAAAAAOnNeQ0=");
    val decoded = CatizenDeploy.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test Catizen in-game task decodes real deployment acknowledgement`() {
    // Outgoing body from mainnet transaction nsPFOrx1G+JRyTWF5BSXULf4d8ObBW4DFB14YVJgnrs=.
    val body = parseCellFromBase64("te6cckEBAQEADgAAGK/5D1cAAAAAAAAAAL0kEhg=");
    val decoded = CatizenDeployOk.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
