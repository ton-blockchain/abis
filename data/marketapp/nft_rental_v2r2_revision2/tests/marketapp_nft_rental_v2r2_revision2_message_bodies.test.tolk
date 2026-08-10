import "@acton/fmt"
import "@acton/io"
import "@acton/testing/expect"
import "../types/marketapp_nft_rental_v2r2_revision2.types"

get fun `test marketapp rent v2r2 revision 2 decodes compatible real signed rent body`() {
    val txHash = "e452017b558ae41ade6494ae55f608fd67a7e124d4217bb44817ea68a9be4d8b";
    val bodyBoc = "te6ccgEBAQEAbwAA2e3Nq2mum2Wuy1p7ER2wYc7S2HjZECPSCDrupf/Z2v8SzDjGRNUe+3ayNIX/zaEBSEATvAK72PcuFHr4EkO3pVfb5BgIQBycOAAAFRgIT4TdoFHl6E454BC2ewQ4GFa4O026/t02ocUCnapqHuQ=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision2Rent.fromCell(body);

    expect(decoded.pricePerDay).toEqual(30000000);
    expect(decoded.duration).toEqual(86400);
    expect(
        decoded.renterPublicKey,
    ).toEqual(0x84f84dda051e5e84e39e010b67b04381856b83b4dbafedd36a1c5029daa6a1ee);
    expect(decoded.referral).toBeNull();
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION2_COMPATIBLE_RENT_TX={}", txHash);
}

get fun `test marketapp rent v2r2 revision 2 decodes real settings sync body`() {
    val txHash = "c97187214994df981122220b3f69ee5a750adb2a006bc4dc3c3f6907eeb67904";
    val bodyBoc = "te6ccgEBAgEAKQABCNV32AoBAD8AAfpAABZpgCBkIsQAAAAAAAAAH0AAAA+jAYvP5WgAQA==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision2SyncRentSettings.fromCell(body);
    val settings = decoded.rentSettings.load();

    expect(settings.autoRelist).toBeFalse();
    expect(settings.minDuration).toEqual(259200);
    expect(settings.maxDuration).toEqual(2937600);
    expect(settings.pricePerDay).toEqual(210000000);
    expect(settings.discountPerDay).toEqual(0);
    expect(settings.discountDenominator).toEqual(1000);
    expect(settings.maxDiscount).toEqual(500);
    expect(settings.salePrice).toEqual(3400000000000);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION2_SYNC_SETTINGS_TX={}", txHash);
}

get fun `test marketapp rent v2r2 revision 2 decodes real outgoing nft transfer`() {
    val txHash = "c97187214994df981122220b3f69ee5a750adb2a006bc4dc3c3f6907eeb67904";
    val bodyBoc = "te6ccgEBAQEAUgAAn1/MPRQAAAAAAAAAIoATZNzn1z6qaZutPVMluTThw5Lxl6l+i3FXJtuPTejEuRAB0CpW6HNTKbRoM4u8AsipV8Vq2YXa25O8A6uf8mdFWeAI";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = MarketAppNftRentalV2R2Revision2NftTransfer.fromCell(body);

    expect(decoded.queryId).toEqual(34);
    expect(decoded.newOwnerAddress).toEqual(
        address("EQCbJuc-ufVTTN1p6pktyacOHJeMvUv0W4q5Ntx6b0YlyH7X"),
    );
    expect(decoded.responseDestination).toBeNotNull();
    expect(decoded.responseDestination!).toEqual(
        address("EQB0CpW6HNTKbRoM4u8AsipV8Vq2YXa25O8A6uf8mdFWeDf6"),
    );
    expect(decoded.customPayload).toBeNull();
    expect(decoded.forwardTonAmount).toEqual(0);
    var tail = decoded.forwardPayload;
    expect(tail.loadBool()).toBeFalse();
    expect(tail.remainingBitsCount()).toEqual(0);
    expect(tail.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("MARKETAPP_V2R2_REVISION2_NFT_TRANSFER_TX={}", txHash);
}
