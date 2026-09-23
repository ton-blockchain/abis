import "@acton/fmt"
import "@acton/testing/expect"
import "../types/blum_memepad_minter.types"
import "../types/blum_memepad_wallet.types"

get fun `test decodes memepad minter buy`() {
    val body = parseCellFromBase64("te6cckEBAgEAJwABJ691DTQAAAAAAAAAAHBiGxA4k1sDAQAcY+DibXhtcXg1T1VqdUejGlhm");
    val decoded = BlumMemepadMinterBuy.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.destination).toBeNull();
    expect(decoded.customPayload != null).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes memepad wallet sell and minter sell notification`() {
    val sellBody = parseCellFromBase64("te6cckEBAgEALQABM3QrNtgAAAAAAAAAAHRJE/bCpAAFAeqe5ITAAQAcY+DibTQ3Y3VabEE1cUR6AcU0");
    val notificationBody = parseCellFromBase64("te6cckEBAgEATgABdbfna/0AAAAAAAAAAHRJE/bCpAAFAeqe5ISAEKyl5DbXCkrbKR/EhdnyRb1qazOHPOlndJbVqzz0OUA4AQAcY+DibTQ3Y3VabEE1cUQKlvGr");
    val sell = BlumMemepadWalletSell.fromCell(sellBody);
    val notification = BlumMemepadMinterSellNotification.fromCell(notificationBody);

    expect(sell.queryId).toEqual(0);
    expect(sell.amount).toEqual(notification.amount);
    expect(sell.minTonAmount).toEqual(notification.minTonAmount);
    expect(sell.toCell().hash()).toEqual(sellBody.hash());
    expect(notification.ownerAddress).toEqual(
        address("0:85652F21B6B85256D948FE242ECF922DEB53599C39E74B3BA4B6AD59E7A1CA01"),
    );
    expect(notification.toCell().hash()).toEqual(notificationBody.hash());
}

get fun `test decodes memepad unlock flow`() {
    val unlockBody = parseCellFromBase64("te6cckEBAQEADgAAGPD9ULsAAAAAAAAAAIB5rl0=");
    val requestBody = parseCellFromBase64("te6cckEBAQEAMAAAWwauFz4AAAAAAAAAAIAYXnrQ1s+LDmbwKFmMQY5xmo9IfvRaZcIaSE5wOTOKrXDNBiJ/");
    val approveBody = parseCellFromBase64("te6cckEBAQEADgAAGLlkQi0AAAAAAAAAAILqUPk=");
    val unlock = BlumMemepadWalletUnlock.fromCell(unlockBody);
    val request = BlumMemepadMinterUnlockRequest.fromCell(requestBody);
    val approve = BlumMemepadWalletUnlockApprove.fromCell(approveBody);

    expect(unlock.queryId).toEqual(0);
    expect(unlock.toCell().hash()).toEqual(unlockBody.hash());
    expect(request.ownerAddress).toEqual(
        address("0:C2F3D686B67C5873378142CC620C738CD47A43F7A2D32E10D2427381C99C556B"),
    );
    expect(request.toCell().hash()).toEqual(requestBody.hash());
    expect(approve.toCell().hash()).toEqual(approveBody.hash());
}

get fun `test decodes memepad minter payouts and failure`() {
    val feeBody = parseCellFromBase64("te6cckEBAgEAIAABGf2qfJ0AAAAAAAAAAMABABxj4OJteG1xeDVPVWp1RwLlh8s=");
    val liquidityFeeBody = parseCellFromBase64("te6cckEBAgEAIAABGZRTTGcAAAAAAAAAAMABABxj4OJtcEV2U2o5MGFKT7Jco18=");
    val sellPayoutBody = parseCellFromBase64("te6cckEBAQEADgAAGK9ezs0AAAAAAAAAAEAfyKQ=");
    val failedBody = parseCellFromBase64("te6cckEBAQEAEgAAIASSQyON2V4JASZ2tgAAAsZA2kIu");
    val fee = BlumMemepadMinterFeePayout.fromCell(feeBody);
    val liquidityFee = BlumMemepadMinterLiquidityFeePayout.fromCell(liquidityFeeBody);
    val sellPayout = BlumMemepadMinterSellPayout.fromCell(sellPayoutBody);
    val failed = BlumMemepadMinterFailed.fromCell(failedBody);

    expect(fee.customPayload != null).toBeTrue();
    expect(fee.toCell().hash()).toEqual(feeBody.hash());
    expect(liquidityFee.toCell().hash()).toEqual(liquidityFeeBody.hash());
    expect(sellPayout.toCell().hash()).toEqual(sellPayoutBody.hash());
    expect(failed.errorCode).toEqual(710);
    expect(failed.toCell().hash()).toEqual(failedBody.hash());
}

get fun `test decodes memepad minter logs`() {
    val buyBody = parseCellFromBase64("te6cckEBAgEAUwABf86sivSACyoBixUaVXtqcyOIX+7TFXV2naKt/kRlhIPpAM5rAygo7msoAOGIbEDiTWwwAuP6tzq4cDqhkxFW7JgBABxj4OJteG1xeDVPVWp1R+jfhNU=");
    val sellBody = parseCellFromBase64("te6cckEBAgEAUgABfe8uLe+AEKyl5DbXCkrbKR/EhdnyRb1qazOHPOlndJbVqzz0OUAqBEJEpnzokifthUgADgoEq+5eqOqE7kGAeAEAHGPg4m00N2N1WmxBNXFEJYyR5Q==");
    val liquidityBody = parseCellFromBase64("te6cckEBAQEAFQAAJjDHIZtgFRbggNXYAsaK8LsUAAAvfpLa");
    val buy = BlumMemepadMinterBuyLog.fromCell(buyBody);
    val sell = BlumMemepadMinterSellLog.fromCell(sellBody);
    val liquidity = BlumMemepadMinterSendLiquidityLog.fromCell(liquidityBody);

    expect(buy.buyerAddress).toEqual(
        address("0:59500C58A8D2ABDB53991C42FF7698ABABB4ED156FF2232C241F480673581941"),
    );
    expect(buy.toCell().hash()).toEqual(buyBody.hash());
    expect(sell.toCell().hash()).toEqual(sellBody.hash());
    expect(liquidity.toCell().hash()).toEqual(liquidityBody.hash());
}
