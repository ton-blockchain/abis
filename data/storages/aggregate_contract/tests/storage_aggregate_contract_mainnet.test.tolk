import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/io"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/storage_aggregate_contract.types"
import "../wrappers/StorageAggregateContract.gen"

const FIXTURE_BOC_PATH = "data/storages/aggregate_contract/testdata/StorageAggregateContract.boc"
const EXPECTED_BOC_MAGIC = 0xb5ee9c72
const EXPECTED_CODE_HASH = 0x385a5f0ddb841c17dd518a327c322d7d098e91c795eb9a152fe9be5cd20e40c9
const EXPECTED_DATA_HASH = 0xe04113de449490d6bf3cc32f58b4f144f701df73564abfa9aaeb6c7bfe90a901
const FIRST_PROVIDER_KEY = 0x861a5c54a9b64d56a02cb0e2b4f89fc9555e0db037e61a507e3b9177558af21f
const PROOF_PROVIDER_KEY = 0xcd1bd248e486b7446a141ec2e37949235aa202941f00cf89e0509968402e1cf0
const PINNED_MAINNET_BLOCK = 71589284
const STORAGE_FIXTURE_MAINNET_BLOCK = 37250356
const EXPECTED_TORRENT_HASH = 0x85d0998dcf325b6fee4f529d4dcf66fb253fc39c59687c82a0ef7fc96fed4c9f
const EXPECTED_MERKLE_HASH = 0x1d35ba415ceda44cc2df559c07033cc8132f4865d0777303fb00214ec1d6d312
const EXPECTED_OWNER = "EQAvyxX5g_GvynfNl_XVQReZ3rstK5bM2OYu9nvren1SRnuN"
const EXPECTED_FILE_SIZE = 188249875
const EXPECTED_CHUNK_SIZE = 131072
const EXPECTED_KEY_LENGTH = 11

const MAINNET_STORAGE_AGGREGATE_ADDRESS = "EQBZw_N1aZaI6ZCc0IJ_NZ-dzfnAbC-qZpU8iMj2ULFGwJ3F"

fun hasBocMagic(bytes: slice): bool {
    if (bytes.remainingBitsCount() < 32) {
        return false;
    }
    return bytes.preloadUint(32) == EXPECTED_BOC_MAGIC;
}

get fun `test storage aggregate contract code boc fixture is real and hash verified`() {
    val rawBoc = fs.readBytes(FIXTURE_BOC_PATH);
    expect(rawBoc).toBeNotNull();
    expect(hasBocMagic(rawBoc!)).toBeTrue();

    val code = build("StorageAggregateContract", FIXTURE_BOC_PATH);
    expect(code.hash()).toEqual(EXPECTED_CODE_HASH);
}

get fun `test storage aggregate contract parses pinned live storage fixture`() {
    val dataBoc = "te6ccgECCwEAAagAAd2F0JmNzzJbb+5PUp1Nz2b7JT/DnFlofIKg73/Jb+1Mn8AC/LFfmD8a/Kd82X9dVBF5neuy0rlszY5i72e+t6fVJGAAAAAAs4dxMAAgAAHTW6QVztpEzC31WcBwM8yBMvSGXQd3MD+wAhTsHW0xILgBAgFYAgMCASAEBQIBYggJAWm/TDS4qVNsmq1AWWHFafE/kqq8G2BvzDSg/Hci7qsV5D4AAAAABs+lCMwvqdEKmYxru9NjywoCAnIGBwFpvnS6BXXNyfL/+AxJ3GchHdXkgdSyo87nu+6slXkFJVBAAAAAAHJdRgzC+qAcQEimErjxIrAKAWm+fl0XT8pwCxRc9Od8JO2CXduULEkL1JcWhK9vfWRDw2AAAAABLQeADMCt4g7uiFaxoOEWEAoBab7vutQrtNLa+XdCi6wIJtA4QDZDTBywd3mJd70+Ci8CiAAAAAAgf+JzMMg+mbIPmOyPA0uMCgFpvujekkckNbojUKD2FxvKSRrVEBSg+AZ8TwKEy0IBcOeAAAAAAArfg2MwyQdW2ftQJ11tITwKAA8AAVGAMERwmA==";
    val data = parseCellFromBase64(dataBoc);
    val storage = StorageAggregateContractStorage.fromCell(data);
    val provider = storage.activeProviders.mustGet(PROOF_PROVIDER_KEY);
    val providerInfo = provider.info.load();
    val contract = StorageAggregateContract.fromAddress(address(MAINNET_STORAGE_AGGREGATE_ADDRESS));

    expect(data.hash()).toEqual(EXPECTED_DATA_HASH);
    expect(contract.address).toEqual(address(MAINNET_STORAGE_AGGREGATE_ADDRESS));
    expect(storage.torrentHash).toEqual(EXPECTED_TORRENT_HASH);
    expect(storage.owner).toEqual(address(EXPECTED_OWNER));
    expect(storage.fileSize).toEqual(EXPECTED_FILE_SIZE);
    expect(storage.chunkSize).toEqual(EXPECTED_CHUNK_SIZE);
    expect(storage.merkleHash).toEqual(EXPECTED_MERKLE_HASH);
    expect(storage.keyLength).toEqual(EXPECTED_KEY_LENGTH);
    expect(storage.activeProviders).toHaveLength(5);
    expect(provider.nextProofByte).toEqual(22802540);
    expect(provider.lastProofTime).toEqual(1712922858);
    expect(provider.nonce).toEqual(15798462587205428263);
    expect(providerInfo.paymentMaxSpan).toEqual(86400);
    expect(providerInfo.ratePerMbDay).toEqual(280329);

    println("STORAGE_AGGREGATE_FIXTURE_MAINNET_BLOCK={}", STORAGE_FIXTURE_MAINNET_BLOCK);
    println("STORAGE_AGGREGATE_ADDRESS={}", contract.address);
    println("STORAGE_AGGREGATE_STORAGE={}", storage);
}

get fun `test storage aggregate contract live storage and getters`() {
    val contract = StorageAggregateContract.fromAddress(address(MAINNET_STORAGE_AGGREGATE_ADDRESS));
    val account = testing.getAccountState(contract.address);
    expect(account).toBeNotNull();

    val accountState = account!.storage.state;
    match (accountState) {
        TlbAccountStateActive => {
            val code = accountState.stateInit.code;
            val data = accountState.stateInit.data;
            expect(code).toBeNotNull();
            expect(data).toBeNotNull();
            expect(code!.hash()).toEqual(EXPECTED_CODE_HASH);

            val storage = StorageAggregateContractStorage.fromCell(data!);
            val firstStoredProvider = storage.activeProviders.mustGet(FIRST_PROVIDER_KEY);
            val firstStoredProviderInfo = firstStoredProvider.info.load();
            val storedProvider = storage.activeProviders.mustGet(PROOF_PROVIDER_KEY);
            val storedProviderInfo = storedProvider.info.load();
            val info = contract.getStorageInfo();
            val provider = contract.getProviderInfo(PROOF_PROVIDER_KEY);
            val availableBalance = contract.getAvailableBalance();
            val providers = contract.getProviders();

            expect(scripts.isContractDeployed(contract.address)).toBeTrue();
            expect(info.torrentHash).toEqual(storage.torrentHash);
            expect(info.fileSize).toEqual(storage.fileSize);
            expect(info.chunkSize).toEqual(storage.chunkSize);
            expect(info.owner.castToInternal()).toEqual(storage.owner);
            expect(info.merkleHash).toEqual(storage.merkleHash);
            expect(provider.nonce).toEqual(storedProvider.nonce);
            expect(provider.lastProofTime).toEqual(storedProvider.lastProofTime);
            expect(provider.nextProofByte).toEqual(storedProvider.nextProofByte);
            expect(provider.paymentMaxSpan).toEqual(storedProviderInfo.paymentMaxSpan);
            expect(provider.ratePerMbDay).toEqual(storedProviderInfo.ratePerMbDay);
            expect(provider.availableContractBalance).toEqual(availableBalance);
            expect(providers.availableBalance).toEqual(availableBalance);
            expect(providers.providers).toHaveLength(5);
            val firstProvider = providers.providers.get(0) as tuple;
            expect(firstProvider).toHaveLength(6);
            expect(firstProvider.get(0) as int).toEqual(FIRST_PROVIDER_KEY);
            expect(firstProvider.get(1) as int).toEqual(firstStoredProviderInfo.ratePerMbDay);
            expect(firstProvider.get(2) as int).toEqual(firstStoredProviderInfo.paymentMaxSpan);
            expect(firstProvider.get(3) as int).toEqual(firstStoredProvider.lastProofTime);
            expect(firstProvider.get(4) as int).toEqual(firstStoredProvider.nextProofByte);
            expect(firstProvider.get(5) as int).toEqual(firstStoredProvider.nonce);

            println("STORAGE_AGGREGATE_PINNED_MAINNET_BLOCK={}", PINNED_MAINNET_BLOCK);
        }
        TlbAccountStateUninit => {
            Assert.fail("TON Storage Aggregate mainnet fixture account is uninitialized");
        }
        TlbAccountStateFrozen => {
            Assert.fail("TON Storage Aggregate mainnet fixture account is frozen");
        }
    }
}
