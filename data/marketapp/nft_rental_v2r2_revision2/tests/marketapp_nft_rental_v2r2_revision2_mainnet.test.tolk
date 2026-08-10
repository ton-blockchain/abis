import "@acton/build"
import "@acton/io"
import "@acton/emulation/scripts"
import "@acton/emulation/testing"
import "@acton/testing/assert"
import "@acton/testing/expect"
import "@acton/types/transaction"
import "../types/marketapp_nft_rental_v2r2_revision2.types"
import "../wrappers/MarketAppNftRentalV2R2Revision2.gen"

const CONTRACT_ADDRESS = "EQBqt5HnOibLNv1xrRTV7RF_Uqgl3EphUFs6L1LtVY4L-5Gb"
const CODE_BOC_PATH = "data/marketapp/nft_rental_v2r2_revision2/testdata/MarketAppNftRentalV2R2Revision2.boc"
const EXPECTED_CODE_HASH = 0x7f14b7a4db7caaf7632ce0aa187968bf2cef7d7fca83f5232aa349b9868bc835
const PINNED_MAINNET_BLOCK = 83585844

fun rentalRevision2(): MarketAppNftRentalV2R2Revision2 {
    return MarketAppNftRentalV2R2Revision2.fromAddress(address(CONTRACT_ADDRESS));
}

fun loadRevision2Storage(
    contract: MarketAppNftRentalV2R2Revision2,
): MarketAppNftRentalV2R2Revision2Storage {
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
                build("MarketAppNftRentalV2R2Revision2", CODE_BOC_PATH).hash(),
            );
            return MarketAppNftRentalV2R2Revision2Storage.fromCell(data!);
        }
        TlbAccountStateUninit => {
            Assert.fail("MarketApp Rent v2r2 Revision 2 is uninitialized at the pinned block");
        }
        TlbAccountStateFrozen => {
            Assert.fail("MarketApp Rent v2r2 Revision 2 is frozen at the pinned block");
        }
    }
}

get fun `test marketapp rent v2r2 revision 2 parses pinned storage and getters`() {
    val contract = rentalRevision2();
    val storage = loadRevision2Storage(contract);
    val identity = storage.identity.load();
    val state = storage.state.load();
    val settings = storage.rentSettings.load();
    val fees = storage.feeSettings.load();

    expect(scripts.isContractDeployed(contract.address)).toBeTrue();
    expect(contract.getPublicKey()).toEqual(storage.publicKey);

    val feeResult = contract.getFees();
    expect(feeResult.recipientAddress.castToInternal()).toEqual(fees.recipientAddress);
    expect(feeResult.numerator).toEqual(fees.numerator);
    expect(feeResult.denominator).toEqual(fees.denominator);

    val stateResult = contract.getState();
    expect(stateResult.status).toEqual(state.status);
    expect(stateResult.rentalDuration).toEqual(state.rentalDuration);
    expect(stateResult.rentalUntil).toEqual(state.rentalUntil);
    expect(stateResult.pricePerDay).toEqual(state.pricePerDay);
    expect(stateResult.renterAddress.castToInternal()).toEqual(state.renterAddress!);
    expect(stateResult.counterpartRentalAddress.castToInternal()).toEqual(
        state.counterpartRentalAddress!,
    );

    val config = contract.getConfig();
    expect(config.autoRelist).toEqual(settings.autoRelist);
    expect(config.minDuration).toEqual(settings.minDuration);
    expect(config.maxDuration).toEqual(settings.maxDuration);
    expect(config.pricePerDay).toEqual(settings.pricePerDay);
    expect(config.discountPerDay).toEqual(settings.discountPerDay);
    expect(config.discountDenominator).toEqual(settings.discountDenominator);
    expect(config.maxDiscount).toEqual(settings.maxDiscount);
    expect(config.salePrice).toEqual(settings.salePrice);

    val identityResult = contract.getMethod12440963178();
    expect(identityResult.ownerAddress.castToInternal()).toEqual(identity.ownerAddress);
    expect(identityResult.nftAddress.castToInternal()).toEqual(identity.nftAddress);
    expect(identityResult.marketplaceAddress.castToInternal()).toEqual(identity.marketplaceAddress);
    expect(identityResult.createdAt).toEqual(identity.createdAt);
    expect(identityResult.role).toEqual(identity.role);
    println("MARKETAPP_V2R2_REVISION2_PINNED_MAINNET_BLOCK={}", PINNED_MAINNET_BLOCK);
}
