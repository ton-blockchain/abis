import "@acton/fmt"
import "@acton/testing/expect"
import "../types/tonfun_bcl_master_v1.types"

get fun `test decodes bcl master buy with explicit buyer`() {
    val body = parseCellFromBase64("te6cckEBAgEAXwABaK91DTSN2V4HAAJCD2HrpsB2VKwAHEkUfKrW5/wvs+e142d3mV8/UNwYueXXEXex/gcI1gMBAEv37OpMgAe7eo6yYTsTlLy6drn+YOOOGF6Tmk/VLaA2vgEoTJXSsFoPfX4=");
    val decoded = TonFunBclMasterBuy.fromCell(body);
    var buyer = decoded.buyerAddress;

    expect(decoded.minReceiveAmount).toEqual(33786025174346);
    expect(decoded.referral != null).toBeTrue();
    expect(buyer.remainingBitsCount()).toEqual(267);
    expect(buyer.loadAddress()).toEqual(
        address("0:1C49147CAAD6E7FC2FB3E7B5E36777995F3F50DC18B9E5D71177B1FE0708D603"),
    );
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes bcl master buy without buyer`() {
    val body = parseCellFromBase64("te6cckEBAQEAFQAAJa91DTQ67Aq5oGSOSWElIGLa2dTZRLTu");
    val decoded = TonFunBclMasterBuy.fromCell(body);

    expect(decoded.referral).toBeNull();
    expect(decoded.buyerAddress.remainingBitsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes bcl master sell coins notification`() {
    val body = parseCellFromBase64("te6cckEBAgEAZQABc2jocP4AAAAAAAAAAHBzEhkglToEMn2JgoAMdcIDWqhoF6dspkmLcmLVnXNCZJq58ZKbeJNaCGK97jgBAEv37OpMgBhOC5TSV930pFErmApFh5URkrpkUxyE6wfMxjOEIhIdUJrongQ=");
    val decoded = TonFunBclMasterSellCoinsNotification.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.referral != null).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes bcl master unlock wallet callback and excess`() {
    val callbackBody = parseCellFromBase64("te6cckEBAQEAMAAAW01YNUkAAAAAAAAAAIAYdGsouXuVkxnmx2rlzbnuNsAAO+YZmCQkzIzCMMX26BAtGWGP");
    val excessBody = parseCellFromBase64("te6cckEBAQEADgAAGKjOP+cAAAAAAAAAAJ0u0Sg=");
    val callback = TonFunBclMasterUnlockWalletCallback.fromCell(callbackBody);
    val excess = TonFunBclMasterUnlockWalletExcess.fromCell(excessBody);

    expect(callback.queryId).toEqual(0);
    expect(callback.toCell().hash()).toEqual(callbackBody.hash());
    expect(excess.queryId).toEqual(0);
    expect(excess.toCell().hash()).toEqual(excessBody.hash());
}

get fun `test decodes bcl master set fees`() {
    val body = parseCellFromBase64("te6cckEBAQEANAAAY0uJw9QAAAAAAAAAAIAFNRu2kLxiY42U6I6NPSONr2QJSBYg2mXFEp93UP7r00AAIAyQkBeeZQ==");
    val decoded = TonFunBclMasterSetFees.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.tradeFeeNumerator).toEqual(1);
    expect(decoded.tradeFeeDenominator).toEqual(100);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes bcl master fee payout and mint`() {
    val feeBody = parseCellFromBase64("te6cckEBAgEAMAABCf2qfJ3AAQBL9+zqTIAHu3qOsmE7E5S8una5/mDjjhhek5pP1S2gNr4BKEyV0rD+Iz4L");
    val mintBody = parseCellFromBase64("te6cckEBAQEANwAAaReNRRmN2V4HAAJCD2IiR4CDeoIADiSKPlVrc/4X2fPa8bO7zK+fqG4MXPLriLvY/wOEawGCDY5zvQ==");
    val fee = TonFunBclMasterFeePayout.fromCell(feeBody);
    val mint = TonFunBclMasterInternalTransfer.fromCell(mintBody);

    expect(fee.referral != null).toBeTrue();
    expect(fee.toCell().hash()).toEqual(feeBody.hash());
    expect(mint.fromAddress).toBeNull();
    expect(mint.forwardTonAmount).toEqual(0);
    expect(mint.toCell().hash()).toEqual(mintBody.hash());
}

get fun `test decodes bcl master payout comment`() {
    val body = parseCellFromBase64("te6cckEBAQEACgAAEAAAAADwn5GN2Q6AJQ==");
    val decoded = TonFunBclMasterPayoutComment.fromCell(body);

    expect(decoded.text.remainingBitsCount()).toEqual(32);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes bcl master buy and sell logs`() {
    val buyBody = parseCellFromBase64("te6cckEBAgEAawABf814Ml2AA4kij5Va3P+F9nz2vGzu8yvn6huDFzy64i72P8DhGsBoF9eEAMREjwEG9RAUx8xDTwo2oMAiQ449bBgBAEv37OpMgAe7eo6yYTsTlLy6drn+YOOOGF6Tmk/VLaA2vgEoTJXSsOzlBSk=");
    val sellBody = parseCellFromBase64("te6cckEBAgEAawABf16X0RaAA4kij5Va3P+F9nz2vGzu8yvn6huDFzy64i72P8DhGsBoF14OQMREjwEG9RAUx4f6XvnHUMAiQhSVvDgBAEv37OpMgAe7eo6yYTsTlLy6drn+YOOOGF6Tmk/VLaA2vgEoTJXSsMD48pM=");
    val buy = TonFunBclMasterBuyLog.fromCell(buyBody);
    val sell = TonFunBclMasterSellLog.fromCell(sellBody);

    expect(buy.referral != null).toBeTrue();
    expect(buy.toCell().hash()).toEqual(buyBody.hash());
    expect(sell.referral != null).toBeTrue();
    expect(sell.toCell().hash()).toEqual(sellBody.hash());
}
