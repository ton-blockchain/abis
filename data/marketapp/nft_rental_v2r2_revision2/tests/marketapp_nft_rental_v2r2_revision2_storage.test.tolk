import "@acton/build"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/marketapp_nft_rental_v2r2_revision2.types"

const EXPECTED_BOC_MAGIC = 0xb5ee9c72

fun loadRevision2Fixture(path: string, contractName: string): cell {
    val bytes = fs.readBytes(path);
    expect(bytes).toBeNotNull();
    expect(bytes!.preloadUint(32)).toEqual(EXPECTED_BOC_MAGIC);
    return build(contractName, path);
}

get fun `test marketapp rent v2r2 revision 2 parses saved mainnet storage`() {
    val code = loadRevision2Fixture(
        "data/marketapp/nft_rental_v2r2_revision2/testdata/MarketAppNftRentalV2R2Revision2.boc",
        "MarketAppNftRentalV2R2Revision2",
    );
    val data = loadRevision2Fixture(
        "data/marketapp/nft_rental_v2r2_revision2/testdata/MarketAppNftRentalV2R2Revision2.data.boc",
        "MarketAppNftRentalV2R2Revision2Data",
    );
    expect(code.hash()).toEqual(0x7f14b7a4db7caaf7632ce0aa187968bf2cef7d7fca83f5232aa349b9868bc835);
    expect(data.hash()).toEqual(0x2de2a3e705b13cc7b734388d88bbd05a634b02ca821fa744c3982c8f25036d15);

    val storage = MarketAppNftRentalV2R2Revision2Storage.fromCell(data);
    val identity = storage.identity.load();
    val state = storage.state.load();
    val settings = storage.rentSettings.load();
    val fees = storage.feeSettings.load();

    expect(identity.ownerAddress).toEqual(
        address("EQDyqX_9TNKZl4_uhKPPQIL-GV3ySY1GxHYmzk8SO5vihGO3"),
    );
    expect(identity.nftAddress).toEqual(
        address("EQBpOb3BaLZOvVsLVw5WECT4UvYzVwrOUTQNNtfpje1D4BOi"),
    );
    expect(identity.marketplaceAddress).toEqual(
        address("EQCanLgK370WYvUQh2bXM1WsLAMwT9odJaR5Zw40781ysx2O"),
    );
    expect(identity.createdAt).toEqual(1785422442);
    expect(identity.role).toEqual(1);

    expect(state.status).toEqual(3);
    expect(state.rentalDuration).toEqual(259200);
    expect(state.rentalUntil).toEqual(1785681642);
    expect(state.pricePerDay).toEqual(210000000);
    expect(state.renterAddress).toBeNotNull();
    expect(state.renterAddress!).toEqual(
        address("EQB9rbMtrcR-6xNtLBDCorK5EwKoB5yqxUTRfeN_Jm898QlV"),
    );
    expect(state.counterpartRentalAddress).toBeNotNull();
    expect(state.counterpartRentalAddress!).toEqual(
        address("EQCbJuc-ufVTTN1p6pktyacOHJeMvUv0W4q5Ntx6b0YlyH7X"),
    );

    expect(settings.autoRelist).toBeFalse();
    expect(settings.minDuration).toEqual(259200);
    expect(settings.maxDuration).toEqual(2937600);
    expect(settings.pricePerDay).toEqual(210000000);
    expect(settings.discountPerDay).toEqual(0);
    expect(settings.discountDenominator).toEqual(1000);
    expect(settings.maxDiscount).toEqual(500);
    expect(settings.salePrice).toEqual(3400000000000);

    expect(fees.recipientAddress).toEqual(
        address("EQB0CpW6HNTKbRoM4u8AsipV8Vq2YXa25O8A6uf8mdFWeDf6"),
    );
    expect(fees.numerator).toEqual(3);
    expect(fees.denominator).toEqual(100);
    expect(
        storage.publicKey,
    ).toEqual(0x84f84dda051e5e84e39e010b67b04381856b83b4dbafedd36a1c5029daa6a1ee);
}
