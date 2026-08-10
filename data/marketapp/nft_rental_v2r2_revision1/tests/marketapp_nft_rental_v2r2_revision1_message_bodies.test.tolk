import "@acton/fmt"
import "@acton/io"
import "@acton/testing/expect"
import "../types/marketapp_nft_rental_v2r2_revision1.types"

get fun `test marketapp rent v2r2 revision 1 decodes real signed rent body`() {
    val txHash = "f8dbc2fc6ed11408a3bcff71cd8952d4d5d49000ad602c34288d3bdc6424e3ae";
    val bodyBoc = "te6ccgEBAQEAbwAA2e3Nq2nzWC+a02peisaTO1H3vLiYYEYpKKlR3n12Rm3LfpR9vmJni2qXERFHyDm9F/Dt6zJ61J5Grw0WiEhi53wk1M8JQBKAVAAAaXgIT4TdoFHl6E454BC2ewQ4GFa4O026/t02ocUCnapqHuQ=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision1Rent.fromCell(body);

    expect(decoded.pricePerDay).toEqual(19400000);
    expect(decoded.duration).toEqual(432000);
    expect(
        decoded.renterPublicKey,
    ).toEqual(0x84f84dda051e5e84e39e010b67b04381856b83b4dbafedd36a1c5029daa6a1ee);
    expect(decoded.referral).toBeNull();
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION1_RENT_TX={}", txHash);
}

get fun `test marketapp rent v2r2 revision 1 decodes real derived-contract marker`() {
    val txHash = "7f48cb063066d8dfca1cc38da82ef891493e87998b8aa4129a84640d5af208a7";
    val bodyBoc = "te6ccgEBAQEABgAACBLRCjI=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision1DeployMarker.fromCell(body);

    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION1_DEPLOY_MARKER_TX={}", txHash);
}

get fun `test marketapp rent v2r2 revision 1 decodes real settings sync body`() {
    val txHash = "5537644e372cf4944a1ded34f13a6f49e9b0a68b1d2b5dd8471ffd8f5e01f510";
    val bodyBoc = "te6ccgEBAgEAIwABCNV32AoBADMAAKjAABZpgCBHhowAAAAAAAAAH0AAAA+gQA==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision1SyncRentSettings.fromCell(body);
    val settings = decoded.rentSettings.load();

    expect(settings.autoRelist).toBeFalse();
    expect(settings.minDuration).toEqual(86400);
    expect(settings.maxDuration).toEqual(2937600);
    expect(settings.pricePerDay).toEqual(150000000);
    expect(settings.discountPerDay).toEqual(0);
    expect(settings.discountDenominator).toEqual(1000);
    expect(settings.maxDiscount).toEqual(500);
    expect(settings.salePrice).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION1_SYNC_SETTINGS_TX={}", txHash);
}

get fun `test marketapp rent v2r2 revision 1 decodes real outgoing nft transfer`() {
    val txHash = "5537644e372cf4944a1ded34f13a6f49e9b0a68b1d2b5dd8471ffd8f5e01f510";
    val bodyBoc = "te6ccgEBAQEAUgAAn1/MPRQAAAAAAAAAIoAV9ACs666+eEt+fYhUAxhr7d7vqCeiklXiuEkD+OnUx1AB9rbMtrcR+6xNtLBDCorK5EwKoB5yqxUTRfeN/Jm898QI";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision1NftTransfer.fromCell(body);

    expect(decoded.queryId).toEqual(34);
    expect(decoded.newOwnerAddress).toEqual(
        address("EQCvoAVnXXXzwlvz7EKgGMNfbvd9QT0Ukq8Vwkgfx06mOpQT"),
    );
    expect(decoded.responseDestination).toBeNotNull();
    expect(decoded.responseDestination!).toEqual(
        address("EQB9rbMtrcR-6xNtLBDCorK5EwKoB5yqxUTRfeN_Jm898QlV"),
    );
    expect(decoded.customPayload).toBeNull();
    expect(decoded.forwardTonAmount).toEqual(0);
    var tail = decoded.forwardPayload;
    expect(tail.loadBool()).toBeFalse();
    expect(tail.remainingBitsCount()).toEqual(0);
    expect(tail.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION1_NFT_TRANSFER_TX={}", txHash);
}
