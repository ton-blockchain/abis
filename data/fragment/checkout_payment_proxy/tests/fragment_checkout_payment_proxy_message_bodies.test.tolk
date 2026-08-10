import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/testing/expect"
import "@acton/types/message"
import "../types/fragment_checkout_payment_proxy.types"
import "../wrappers/FragmentCheckoutPaymentProxy.gen"

const CODE_PATH = "data/fragment/checkout_payment_proxy/testdata/FragmentCheckoutPaymentProxy.boc"
const DATA_PATH = "data/fragment/checkout_payment_proxy/testdata/FragmentCheckoutPaymentProxy.data.boc"
const CODE_HASH = 0xa7c2e6591f823692dcf4ccdb90a6d2ac83ec9b513a4e7076249e0a056f0aad32
const DATA_HASH = 0x96a296d224f285c67bee93c30f8a309157f0daa35dc5b87e410b78630a09cfc7

fun loadCheckoutRawMessage(
    mutate actions: RemainingBitsAndRefs,
    expectedMode: int,
    expectedHash: int,
): TlbMessageRelaxed<RemainingBitsAndRefs> {
    expect(actions.remainingBitsCount()).toBeGreater(7);
    expect(actions.remainingRefsCount()).toBeGreater(0);
    expect(actions.loadUint(8)).toEqual(expectedMode);

    val messageCell = actions.loadRef();
    expect(messageCell.hash()).toEqual(expectedHash);
    return (messageCell as Cell<TlbMessageRelaxed<RemainingBitsAndRefs>>).load({
        assertEndAfterReading: false,
    });
}

fun expectEmptyCheckoutBody(message: TlbMessageRelaxed<RemainingBitsAndRefs>): void {
    val body = message.loadBody();
    expect(body.remainingBitsCount()).toEqual(0);
    expect(body.remainingRefsCount()).toEqual(0);
}

get fun `test Fragment checkout proxy code and real payment batch`() {
    val codeBytes = fs.readBytes(CODE_PATH);
    val dataBytes = fs.readBytes(DATA_PATH);
    expect(codeBytes).toBeNotNull();
    expect(dataBytes).toBeNotNull();
    expect(codeBytes!.preloadUint(32)).toEqual(0xb5ee9c72);
    expect(dataBytes!.preloadUint(32)).toEqual(0xb5ee9c72);
    expect(build("FragmentCheckoutPaymentProxy", CODE_PATH).hash()).toEqual(CODE_HASH);
    val data = build("FragmentCheckoutPaymentProxyData", DATA_PATH);
    expect(data.hash()).toEqual(DATA_HASH);
    expect(FragmentCheckoutPaymentProxyStorage.fromCell(data).toCell().hash()).toEqual(DATA_HASH);
    expect(
        FragmentCheckoutPaymentProxy.fromStorage(FragmentCheckoutPaymentProxyStorage {}).address,
    ).toEqual(address("EQBELNs-kCde5ynY1RBv3Dtui5rOnP2i00WjQroPoLMKZ8aM"));

    val body = parseCellFromBase64("te6cckEBBQEA5wADHmiJMDx2pIbuF3qUOBECggECAwG4YgAgRtHZRbYDLSyfCByJNN1VTi/GV14GNOz4VV3VlUyStagVJBoMAAAAAAAAAAAAAAAAAAAAAAAAVGVsZWdyYW0gUHJlbWl1bSBmb3IgNiBtb250aHMgCgpSZWYEAGhiAHn55+RehX+0WgUMpAq1Gub7V0qH0Mx3l3xvFHPqnHHtoGw99gAAAAAAAAAAAAAAAAAAAGBiAA50bkSskHE0xsbYIY3dNPIHdQDs7mD6IDDsjT0wzKjKgAAAAAAAAAAAAAAAAAAAFCMzeVpJOVFJSHkjvwAZ");
    val decoded = FragmentCheckoutPaymentBatch.fromCell(body);
    expect(decoded.requestId).toEqual(0x76a486ee177a9438);

    var actions = decoded.actions;
    val purchase = loadCheckoutRawMessage(
        mutate actions,
        0x11,
        0x7a4fde80d92ccde47a165ccee55a60dc3503a65bad7d299c51e3f3fde2beaf2c,
    );
    expect(purchase.info.dest).toEqual(
        address("EQBAjaOyi2wGWlk-EDkSabqqnF-MrrwMadnwqrurKpkla9nE"),
    );
    expect(purchase.info.value.grams).toEqual(11350000000);
    val purchaseBody = purchase.loadBody();
    expect(purchaseBody.remainingBitsCount()).toEqual(312);
    expect(purchaseBody.remainingRefsCount()).toEqual(1);
    expect(purchaseBody.preloadUint(32)).toEqual(0);

    val serviceFee = loadCheckoutRawMessage(
        mutate actions,
        0x02,
        0x9d063069682de029ea424447c98356679bc9ee30c99a328ba7e84d3749ca07fb,
    );
    expect(serviceFee.info.dest).toEqual(
        address("EQDz88_IvQr_aLQKGUgVajXN9q6VD6GY7y743ijn1Tjj278X"),
    );
    expect(serviceFee.info.value.grams).toEqual(227000000);
    expectEmptyCheckoutBody(serviceFee);

    val remainingValue = loadCheckoutRawMessage(
        mutate actions,
        0x82,
        0x5c0347b4815569544e0fa5fb0c979eecf1532ce9e57d91ea9dbe22ad0ad25da0,
    );
    expect(remainingValue.info.dest).toEqual(
        address("EQAc6NyJWSDiaY2NsEMbumnkDuoB2dzB9EBh2Rp6YZlRlZ08"),
    );
    expect(remainingValue.info.value.grams).toEqual(0);
    expectEmptyCheckoutBody(remainingValue);

    expect(actions.remainingBitsCount()).toEqual(0);
    expect(actions.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
