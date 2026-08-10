import "@acton/build"
import "@acton/io"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/marketapp_nft_rental_v2r2_revision1.types"
import "../wrappers/MarketAppNftRentalV2R2Revision1.gen"

const CONTRACT_ADDRESS = "EQAleBMirXy3ymMv-uXiR3DyiuSeIT8x2kst8JMAhxN0B3tO"
const CODE_BOC_PATH = "data/marketapp/nft_rental_v2r2_revision1/testdata/MarketAppNftRentalV2R2Revision1.boc"
const EXPECTED_CODE_HASH = 0x42c6cb85fc037291674a2c61a0dae6756df24f39b6ec8bca463b79fb7564d141
const PINNED_MAINNET_BLOCK = 83585844

fun rentalRevision1(): MarketAppNftRentalV2R2Revision1 {
    return MarketAppNftRentalV2R2Revision1.fromAddress(address(CONTRACT_ADDRESS));
}

fun loadRevision1Storage(
    contract: MarketAppNftRentalV2R2Revision1,
): MarketAppNftRentalV2R2Revision1Storage {
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
                build("MarketAppNftRentalV2R2Revision1", CODE_BOC_PATH).hash(),
            );
            return MarketAppNftRentalV2R2Revision1Storage.fromCell(data!);
        }
        TlbAccountStateUninit => {
            Assert.fail("MarketApp Rent v2r2 Revision 1 is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("MarketApp Rent v2r2 Revision 1 is frozen at the pinned block");
        }
    }
}

get fun `test marketapp rent v2r2 revision 1 parses pinned storage and public key`() {
    val contract = rentalRevision1();
    val storage = loadRevision1Storage(contract);
    val identity = storage.identity.load();

    expect(scripts.isContractDeployed(contract.address)).toBeTrue();
    expect(contract.getPublicKey()).toEqual(storage.publicKey);
    expect(identity.ownerAddress).toEqual(
        address("EQAlBhF0ZmkY15_g56X_df1BX67HTzHjCyael7PsqSghAwZK"),
    );
    expect(identity.nftAddress).toEqual(
        address("EQBFr8InUD2JkFM1B2VM9RrKto05tAGyKw9_GJXSLUhP9AaT"),
    );
    expect(identity.marketplaceAddress).toEqual(
        address("EQCanLgK370WYvUQh2bXM1WsLAMwT9odJaR5Zw40781ysx2O"),
    );
    expect(identity.role).toEqual(0);
    println("MARKETAPP_V2R2_REVISION1_PINNED_MAINNET_BLOCK={}", PINNED_MAINNET_BLOCK);
}
