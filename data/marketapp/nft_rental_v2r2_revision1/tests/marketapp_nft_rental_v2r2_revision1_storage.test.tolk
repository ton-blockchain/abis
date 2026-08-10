import "@acton/build"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/marketapp_nft_rental_v2r2_revision1.types"

const EXPECTED_BOC_MAGIC = 0xb5ee9c72

fun loadRevision1Fixture(path: string, contractName: string): cell {
    val bytes = fs.readBytes(path);
    expect(bytes).toBeNotNull();
    expect(bytes!.preloadUint(32)).toEqual(EXPECTED_BOC_MAGIC);
    return build(contractName, path);
}

get fun `test marketapp rent v2r2 revision 1 parses saved mainnet storage`() {
    val code = loadRevision1Fixture(
        "data/marketapp/nft_rental_v2r2_revision1/testdata/MarketAppNftRentalV2R2Revision1.boc",
        "MarketAppNftRentalV2R2Revision1",
    );
    val data = loadRevision1Fixture(
        "data/marketapp/nft_rental_v2r2_revision1/testdata/MarketAppNftRentalV2R2Revision1.data.boc",
        "MarketAppNftRentalV2R2Revision1Data",
    );
    expect(code.hash()).toEqual(0x42c6cb85fc037291674a2c61a0dae6756df24f39b6ec8bca463b79fb7564d141);
    expect(data.hash()).toEqual(0xf271f290d4563c07fdb7e4c79a27c3470b7d6492b0374e412249d37fef86f3f9);

    val storage = MarketAppNftRentalV2R2Revision1Storage.fromCell(data);
    val identity = storage.identity.load();
    val state = storage.state.load();
    val settings = storage.rentSettings.load();
    val fees = storage.feeSettings.load();

    expect(identity.ownerAddress).toEqual(
        address("EQAlBhF0ZmkY15_g56X_df1BX67HTzHjCyael7PsqSghAwZK"),
    );
    expect(identity.nftAddress).toEqual(
        address("EQBFr8InUD2JkFM1B2VM9RrKto05tAGyKw9_GJXSLUhP9AaT"),
    );
    expect(identity.marketplaceAddress).toEqual(
        address("EQCanLgK370WYvUQh2bXM1WsLAMwT9odJaR5Zw40781ysx2O"),
    );
    expect(identity.createdAt).toEqual(1767475640);
    expect(identity.role).toEqual(0);

    expect(state.status).toEqual(3);
    expect(state.rentalDuration).toEqual(0);
    expect(state.rentalUntil).toEqual(0);
    expect(state.pricePerDay).toEqual(0);
    expect(state.renterAddress).toBeNull();
    expect(state.counterpartRentalAddress).toBeNull();

    expect(settings.autoRelist).toBeFalse();
    expect(settings.minDuration).toEqual(86400);
    expect(settings.maxDuration).toEqual(2937600);
    expect(settings.pricePerDay).toEqual(19400000);
    expect(settings.discountPerDay).toEqual(0);
    expect(settings.discountDenominator).toEqual(1000);
    expect(settings.maxDiscount).toEqual(500);
    expect(settings.salePrice).toEqual(0);

    expect(fees.recipientAddress).toEqual(
        address("EQB0CpW6HNTKbRoM4u8AsipV8Vq2YXa25O8A6uf8mdFWeDf6"),
    );
    expect(fees.numerator).toEqual(2);
    expect(fees.denominator).toEqual(100);
    expect(
        storage.publicKey,
    ).toEqual(0x3e4ecf06f5270dd341c515dd28e6f8f0a0191465759985477edf2d10aa7fa780);
}
