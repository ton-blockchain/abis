import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/frt_gram_swap_executor.types"

const EXECUTOR_CODE_PATH = "data/frt_gram_adapter/testdata/FrtGramSwapExecutor.boc"
const EXECUTOR_DATA_PATH = "data/frt_gram_adapter/testdata/FrtGramSwapExecutor.data.boc"
const EXECUTOR_CODE_HASH = 0xe46c2316b3543b5a64e87bf7ce1f430ec76b94b7e524f2e85b8737de25de643f
const EXECUTOR_DATA_HASH = 0xbf46449ee5821bed0451f7555591ba4697d6d5b960bab909910e9f9316323814
const PRIMARY_CONTROLLER = "EQA_LY9WjuDSFsjtNGqBb5M8QQzmaMf9P8-MTPkFCHQ9PoFq"
const SECONDARY_CONTROLLER = "EQB5E8tp3GLdG0G5tfuB1btv3h7fYiCrDW9AwmZydxAXAnXL"
const CURRENT_AUTHORIZATION_ROOT = 0x90b3e4291b27e47aaa61aa3c28eac223bd54ae13882b5ab5e2a9ec67bd081207
const REQUEST_RECEIVER = "0:B399263135C25348B355EC651F6DBF9286ACBB7CE64D3EC82171352DC5DA99AE"
const REQUEST_AUTHORIZATION_HASH = 0xeba6bb0ea7dd523317231c4376a5479859f6d5949073b1febd080052426ee487
const PTON_REFUND_ADDRESS = "0:B399263135C25348B355EC651F6DBF9286ACBB7CE64D3EC82171352DC5DA99AE"
const STONFI_TOKEN_WALLET = "0:C225DC2193337F87DFC80116999EA6C568AF0FE3769A036DBEC7E0260EFE36BC"
const STONFI_REFERRAL_ADDRESS = "0:5BF91882C7B6699C79F0FC0EF0C4296C8EF97240D89B784E7B4157D217B88326"

fun expectBoc(path: string): void {
    val bytes = fs.readBytes(path);
    expect(bytes).toBeNotNull();
    expect(bytes!.preloadUint(32)).toEqual(0xb5ee9c72);
}

get fun `test ForTON swap executor code and data fixtures`() {
    expectBoc(EXECUTOR_CODE_PATH);
    expectBoc(EXECUTOR_DATA_PATH);

    val code = build("FrtGramSwapExecutorCode", EXECUTOR_CODE_PATH);
    val data = build("FrtGramSwapExecutorData", EXECUTOR_DATA_PATH);
    val storage = FrtGramSwapExecutorStorage.fromCell(data);

    expect(code.hash()).toEqual(EXECUTOR_CODE_HASH);
    expect(data.hash()).toEqual(EXECUTOR_DATA_HASH);
    expect(storage.toCell().hash()).toEqual(data.hash());
    expect(storage.initialized).toBeTrue();
    expect(storage.primaryController).toEqual(address(PRIMARY_CONTROLLER));
    expect(storage.secondaryController).toEqual(address(SECONDARY_CONTROLLER));
    expect(storage.authorizationRoot).toEqual(CURRENT_AUTHORIZATION_ROOT);
    expect(storage.paused).toBeFalse();
}

get fun `test ForTON swap executor decodes real incoming request`() {
    // tx uYarR4GqVY1xXkZgwOxSsX70qDSzLOI2qFRat+Grtkg=.
    val bodyBoc = "te6cckECIwEAAzIAAUvoTWrFgBZzJMYmuEppFmq9jKPtt/JQ1ZdvnMmn2QQuJqW4u1M10AEJRgOQs+QpGyfkeqphqjwo6sIjvVSuE4grWrXiqexnvQgSBwAUAiIFgXACAwQoSAEB7+ro5yLF+2sxBcWwsqGfJhRtXu6MmT3u9eviCJ+pj1YAEyIBIAUGIgEgBwgoSAEBMwDCo6WfArRMvpnJCVPqoqdnEYmxNuIaYWaibXe5ZToAEihIAQGqv9NmmtuBeluNEGD2tGSqxaZcxXvmej+L3Hpeh8n8SgAQIgEgCQooSAEBN8OM+usJizjn1xdv7At9Zng9TMcXLXwFpPBHLEIVOLEADyIBIAsMIgEgDQ4oSAEB66qsubpvVicRkh94wBDrmO9JDYdkiyq7GmhtRw3KEoYADSIBIA8QKEgBAVK7K+r/uOlUKIK4ZQF0YDcridjG4MwK5EqF2mWnc3vpAAwoSAEBbLxCQgUB6s4yqQ7DGGuOcQ5uShfNsq3Vq0wgmocu3ysACyIBIBESKEgBAW6OMnto2CBXXO3l13HHFr6+r4KnIkZlsVaMTuKx6eC5AAoiASATFChIAQFtFfgVX7fqyAnbHb07qNUwRLP3XAA3VArNRspBiVY3FwAJIgEgFRYiASAXGChIAQEKMdDv15N39HOIH+Mkaz/dhwbaxE37sOXeVO/fatd8YQAIIgEgGRooSAEBr2S810oGR4x/RSXMWVxPQM9+gFmeNk/iheGfgZDJGr0ABihIAQELtufJcWQjTm/Gir3rv3/vV5Gturb3JR6yi3y1GjT8cgAEIgEgGxwoSAEBIiIm0OIR72Hfkfrw8nFUZpMcEp0u/MVoJuQm2LE8oYsAAyIBIB0eIgEgHyAoSAEB/NZrtuLzhN3Q0OvDl4EUKbrYO6Nh9fC+Nawxs6hlwGUAASIBaiEiKEgBAepVpvj5oLdKerfCx2KVyXpYioBIxH+0ttkIm5hSHQbDAAMAXbumMTXCU0izVexlH22/koasu3zmTT7IIXE1LcXama47cbAAAAanm+fAAAaoL3wIKEgBAUOdE/O7VG6i3F+45MhqgBa8c16x99Pk9uus0AcZ78l7AACCe+uV";
    val decoded = ForTonFrtSwapRequest.fromCell(parseCellFromBase64(bodyBoc));

    expect(decoded.receiver).toEqual(address(REQUEST_RECEIVER));
    expect(decoded.routeAuthorization.hash()).toEqual(REQUEST_AUTHORIZATION_HASH);
}

get fun `test ForTON swap executor decodes real pTON STON.fi output`() {
    // tx uYarR4GqVY1xXkZgwOxSsX70qDSzLOI2qFRat+Grtkg=, out[0].
    val bodyBoc = "te6cckEBAwEA8gABYgHzg10AAAAAAAAAADtxsAgBZzJMYmuEppFmq9jKPtt/JQ1ZdvnMmn2QQuJqW4u1M10BAeFmZN4qgBhEu4QyZm/w+/kAItMz1NitFeH8btNAbbfY/ATB38bXkALOZJjE1wlNIs1XsZR9tv5KGrLt85k0+yCFxNS3F2pmugBZzJMYmuEppFmq9jKPtt/JQ1ZdvnMmn2QQuJqW4u1M1wAAAAA1PSW5QAIAjxAYAWcyTGJrhKaRZqvYyj7bfyUNWXb5zJp9kELialuLtTNcAAAyQAW/kYgse2aZx58PwO8MQpbI75ckDYm3hOe0FX0he4gyaKmJT9w=";
    val decoded = FrtGramSwapExecutorPtonTonTransfer.fromCell(parseCellFromBase64(bodyBoc));
    var forwardPayload = decoded.forwardPayload;

    expect(decoded.queryId).toEqual(0);
    expect(decoded.tonAmount).toEqual(12000000);
    expect(decoded.refundAddress).toEqual(address(PTON_REFUND_ADDRESS));
    expect(forwardPayload.remainingBitsCount()).toEqual(1);
    expect(forwardPayload.remainingRefsCount()).toEqual(1);
    expect(forwardPayload.loadBool()).toBeTrue();

    val stonfiSwap = FrtGramSwapExecutorStonfiV2SwapPayload.fromCell(
        forwardPayload.loadRef(),
    );
    val swapBody = stonfiSwap.swapBody.load();
    expect(stonfiSwap.tokenWallet).toEqual(address(STONFI_TOKEN_WALLET));
    expect(stonfiSwap.refundAddress).toEqual(address(PTON_REFUND_ADDRESS));
    expect(stonfiSwap.excessesAddress).toEqual(address(PTON_REFUND_ADDRESS));
    expect(stonfiSwap.deadline).toEqual(1786399602);
    expect(swapBody.minOut).toEqual(1);
    expect(swapBody.receiver).toEqual(address(PTON_REFUND_ADDRESS));
    expect(swapBody.forwardGas).toEqual(0);
    expect(swapBody.customPayload).toBeNull();
    expect(swapBody.refundForwardGas).toEqual(0);
    expect(swapBody.refundPayload).toBeNull();
    expect(swapBody.referralFee).toEqual(100);
    expect(swapBody.referralAddress).toEqual(address(STONFI_REFERRAL_ADDRESS));
    expect(forwardPayload.remainingBitsCount()).toEqual(0);
    expect(forwardPayload.remainingRefsCount()).toEqual(0);
}
