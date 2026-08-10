import "@acton/build"
import "@acton/fmt"
import "@acton/testing/expect"
import "../types/jetton_vesting.types"

const EXPECTED_CODE_HASH = 0xb360d6da4bb86554459ca38c3ec6f26e932370743eacf1219cad54ee006b5ca6
const CODE_BOC_PATH = "data/jetton_vesting/testdata/JettonVesting.boc"

fun expectInlineEmptyForwardPayload(mutate payload: RemainingBitsAndRefs): void {
    expect(payload.remainingBitsCount()).toEqual(1);
    expect(payload.remainingRefsCount()).toEqual(0);
    expect(payload.loadBool()).toBeFalse();
    expect(payload.remainingBitsCount()).toEqual(0);
    expect(payload.remainingRefsCount()).toEqual(0);
}

get fun `test jetton vesting code fixture matches live revision`() {
    val code = build("JettonVesting", CODE_BOC_PATH);
    expect(code.hash()).toEqual(EXPECTED_CODE_HASH);
}

get fun `test jetton vesting decodes real claim token body`() {
    // Toncenter transaction /JCh1zsx9oT/HIGgr5MCT4qMwC0bpao4Q2AjcBfppMI=,
    // incoming message logical time 72777876000005.
    val bodyBoc = "te6cckEBAQEAUgAAn89Pk3MAAAAAAAAAAIADAKQnABrXK9DEDFNMVn11mKFeS47S7RxudTbgI2cLsigAMApCcAGtcr0MQMU0xWfXWYoV5LjtLtHG51NuAjZwuyII/zAh3g==";
    val destination = address("0:1805213800D6B95E8620629A62B3EBACC50AF25C769768E373A9B7011B385D91");
    val body = parseCellFromBase64(bodyBoc);
    val claim = JettonVestingClaimToken.fromCell(body);

    expect(claim.queryId).toEqual(0);
    expect(claim.destination).toEqual(destination);
    expect(claim.amount).toBeNull();
    expect(claim.responseDestination).toEqual(destination);
    expect(claim.forwardTonAmount).toEqual(0);
    expect(claim.toCell().hash()).toEqual(body.hash());
    var forwardPayload = claim.forwardPayload;
    expectInlineEmptyForwardPayload(mutate forwardPayload);
}

get fun `test jetton vesting decodes real allocation update and excess response`() {
    // Incoming and outgoing bodies of Toncenter transaction kXNHPgUso6jaW2D50WnWYuqyrsOwI6YrtZnKqPTbyJU=
    // at logical time 65161914000007.
    val updateBody = parseCellFromBase64("te6cckEBAQEACwAAEbFI0n9Au9+0CKhMcMU=");
    val excessBody = parseCellFromBase64("te6cckEBAQEADgAAGNUydtsAAAAAAAAAAPfBmNw=");
    val update = JettonVestingOpcodeB148d27f.fromCell(updateBody);
    val excess = JettonVestingExcesses.fromCell(excessBody);

    expect(update.amount).toEqual(197000000);
    expect(update.toCell().hash()).toEqual(updateBody.hash());
    expect(excess.queryId).toEqual(0);
    expect(excess.toCell().hash()).toEqual(excessBody.hash());
}

get fun `test jetton vesting preserves real referenced protocol payload`() {
    // Incoming and outgoing bodies of Toncenter transaction iBlMzn4PiJHvxlL3Zm3vNeUW6p6yvtRDi6JrwFr3TzI=
    // at logical time 65161914000003.
    val requestBody = parseCellFromBase64("te6cckECIQEAAv4AAQhnjtg9AQlGAyt3B4wHlBZ/ME+sKsVUInxK2/agA3/Bsf5R6I4DeT0xABMCIgWBcAIDBCIBIAUGKEgBAQ08le0UtTMyIHA92vtYVvpnjMrrrVD7079yxrqp5bBCABIiASAHCChIAQEWazxaverSVgLO4R/B7NwkvkY1ExmHzf5xMPBn+txV+gAQIgEgCQooSAEBQ20vaZCTZKGClo+AKCleyCw0uaO84cpu6AmiIRoZ9O0ADyhIAQEcChJ5EzC6Rw4o/zfEOzI8P1+OsC2D6LcrnVXziaHJAgAOIgEgCwwoSAEBP76JAXWLSx6uTaG4XuDoovpACXzg7fASQ2gJwTkTrmEADiIBIA0OIgEgDxAoSAEBJE2APghxdAcv63Sr3WFtULXtmzyzSrQrg/QlP/NucusACyIBIBESKEgBAUkQ85lAo2AP0hK0rZE+9bx8Xc6dCNs/hskfCAaM2TGoAAsiASATFChIAQEPHZ4/6TjlPmb315f35tfrhwqzV+hxpHJwzKvlSG3T4QAJIgEgFRYoSAEBi5ZX7LmzsmhTL1F/HdV7Zrg2jOP60xYhgkeadMuNidQAByIBIBcYKEgBAfMFy10eMTL13VvSTucAWkvWRfgADTHEOJri4DvMI3NXAAciASAZGihIAQFt0tmp/REfhYeaKKgCQGde4AHyY0jI4GVQ8bnIYxoCrAAFIgEgGxwoSAEBKDqY23j0Xriagvi6IzhgVH/wzZjZJCxTWe+ayHc10qMABQIBIB0eKEgBAQULKnne61ZKpNOymcrpQzfMvFSkzOAIEgBX3mDchSE0AAIAYLyEFqQsAp6N3fM92N5aiBTcsruUxkcvd6QxZ3PiwXykIGzIAAAAAAAAAAAAe+/cEQIBIB8gAF+8ZCcAGtcr0MQMU0xWfXWYoV5LjtLtHG51NuAjZwuyKBd79oAAAAAAAAAAAPffuCMAX7xyYqULPlfjWvU0a7X3xw2+7MWew1xRNEXqSSsjhoCoEM76gAAAAAAAAAAA99+4IxtKTcY=");
    val responseBody = parseCellFromBase64("te6cckECIQEAAyAAAUs5ustfgAMApCcAGtcr0MQMU0xWfXWYoV5LjtLtHG51NuAjZwuyMAEJRgMrdweMB5QWfzBPrCrFVCJ8Stv2oAN/wbH+UeiOA3k9MQATAiIFgXACAwQiASAFBihIAQENPJXtFLUzMiBwPdr7WFb6Z4zK661Q+9O/csa6qeWwQgASIgEgBwgoSAEBFms8Wr3q0lYCzuEfwezcJL5GNRMZh83+cTDwZ/rcVfoAECIBIAkKKEgBAUNtL2mQk2ShgpaPgCgpXsgsNLmjvOHKbugJoiEaGfTtAA8oSAEBHAoSeRMwukcOKP83xDsyPD9fjrAtg+i3K51V84mhyQIADiIBIAsMKEgBAT++iQF1i0serk2huF7g6KL6QAl84O3wEkNoCcE5E65hAA4iASANDiIBIA8QKEgBASRNgD4IcXQHL+t0q91hbVC17Zs8s0q0K4P0JT/zbnLrAAsiASAREihIAQFJEPOZQKNgD9IStK2RPvW8fF3OnQjbP4bJHwgGjNkxqAALIgEgExQoSAEBDx2eP+k45T5m99eX9+bX64cKs1focaRycMyr5Uht0+EACSIBIBUWKEgBAYuWV+y5s7JoUy9Rfx3Ve2a4Nozj+tMWIYJHmnTLjYnUAAciASAXGChIAQHzBctdHjEy9d1b0k7nAFpL1kX4AA0xxDia4uA7zCNzVwAHIgEgGRooSAEBbdLZqf0RH4WHmiioAkBnXuAB8mNIyOBlUPG5yGMaAqwABSIBIBscKEgBASg6mNt49F64moL4uiM4YFR/8M2Y2SQsU1nvmsh3NdKjAAUCASAdHihIAQEFCyp53utWSqTTspnK6UM3zLxUpMzgCBIAV95g3IUhNAACAGC8hBakLAKejd3zPdjeWogU3LK7lMZHL3ekMWdz4sF8pCBsyAAAAAAAAAAAAHvv3BECASAfIABfvGQnABrXK9DEDFNMVn11mKFeS47S7RxudTbgI2cLsigXe/aAAAAAAAAAAAD337gjAF+8cmKlCz5X41r1NGu198cNvuzFnsNcUTRF6kkrI4aAqBDO+oAAAAAAAAAAAPffuCP1x9E7");
    val request = JettonVestingOpcode678ed83d.fromCell(requestBody);
    val response = JettonVestingOpcode39bacb5f.fromCell(responseBody);

    expect(response.ownerAddress).toEqual(
        address("0:1805213800D6B95E8620629A62B3EBACC50AF25C769768E373A9B7011B385D91"),
    );
    expect(request.payload.hash()).toEqual(response.payload.hash());
    expect(request.toCell().hash()).toEqual(requestBody.hash());
    expect(response.toCell().hash()).toEqual(responseBody.hash());
}

get fun `test jetton vesting decodes real emitted jetton transfer body`() {
    // Outgoing message of Toncenter transaction
    // /JCh1zsx9oT/HIGgr5MCT4qMwC0bpao4Q2AjcBfppMI= at logical time 72777876000006.
    val bodyBoc = "te6cckEBAQEAVQAApg+KfqUAAAAAAAAAADSUSCgAMApCcAGtcr0MQMU0xWfXWYoV5LjtLtHG51NuAjZwuyMABgFITgA1rlehiBimmKz66zFCvJcdpdo43OptwEbOF2RAv4+qEQ==";
    val destination = address("0:1805213800D6B95E8620629A62B3EBACC50AF25C769768E373A9B7011B385D91");
    val body = parseCellFromBase64(bodyBoc);
    val transfer = JettonVestingJettonTransfer.fromCell(body);

    expect(transfer.queryId).toEqual(0);
    expect(transfer.amount).toEqual(4801666);
    expect(transfer.destination).toEqual(destination);
    expect(transfer.responseDestination).toEqual(destination);
    expect(transfer.customPayload).toBeNull();
    expect(transfer.forwardTonAmount).toEqual(0);
    expect(transfer.toCell().hash()).toEqual(body.hash());
    var forwardPayload = transfer.forwardPayload;
    expectInlineEmptyForwardPayload(mutate forwardPayload);
}
