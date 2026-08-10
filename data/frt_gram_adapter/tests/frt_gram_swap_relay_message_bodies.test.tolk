import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/frt_gram_swap_relay.types"

const RELAY_CODE_PATH = "data/frt_gram_adapter/testdata/FrtGramSwapRelay.boc"
const RELAY_DATA_PATH = "data/frt_gram_adapter/testdata/FrtGramSwapRelay.data.boc"
const RELAY_CODE_HASH = 0x533695fd5bdbcb202f3b1143ec008b76043447b08a17448ed2479a7508ab8638
const RELAY_DATA_HASH = 0xaaf14c27acd96a2f9eb00fdad1184ffe641708a4c4d025897df12f173a165aa0
const RECEIVER = "EQDjTZritjDsup_dE1ni4bM_jGvqO3ijuLbzuTscqGAoJivA"
const EXECUTOR = "EQDNGuEuxoPuw6XafMT-HWJ0lDUHrITLty9hDYru2CKmt_2L"
const AUTHORIZATION_ROOT = 0x05177925fc1085cfd0d03cc48036e3b217e8bc60024e16ad58c0c4f15b9ca14c
const AUTHORIZATION_CELL_HASH = 0xa83a66bc936bdf11e7d420dd6a7135c43f8295eefc07f10bc31d92b14b7b9fa8

fun expectBoc(path: string): void {
    val bytes = fs.readBytes(path);
    expect(bytes).toBeNotNull();
    expect(bytes!.preloadUint(32)).toEqual(0xb5ee9c72);
}

get fun `test ForTON swap relay code and data fixtures`() {
    expectBoc(RELAY_CODE_PATH);
    expectBoc(RELAY_DATA_PATH);

    val code = build("FrtGramSwapRelayCode", RELAY_CODE_PATH);
    val data = build("FrtGramSwapRelayData", RELAY_DATA_PATH);
    val storage = FrtGramSwapRelayStorage.fromCell(data);

    expect(code.hash()).toEqual(RELAY_CODE_HASH);
    expect(data.hash()).toEqual(RELAY_DATA_HASH);
    expect(storage.toCell().hash()).toEqual(data.hash());
    expect(storage.initialized).toBeTrue();
    expect(storage.receiver).toEqual(address(RECEIVER));
    expect(storage.executor).toEqual(address(EXECUTOR));
    expect(storage.authorizationRoot).toEqual(AUTHORIZATION_ROOT);
    expect(storage.processed).toBeTrue();
}

get fun `test ForTON swap relay decodes and preserves real request body`() {
    // tx RYqi45+qIVDcYjj50shxneiiXy7EFgGMzMdsZYmI5Ww=, incoming and outgoing body.
    val bodyBoc = "te6cckECIQEAAwgAAUvoTWrFgBxps1xWxh2XU/uiazxcNmfxjX1HbxR3Ft53J2OVDAUE0AEJRgMFF3kl/BCFz9DQPMSANuOyF+i8YAJOFq1YwMTxW5yhTAAUAiIFgXACAwQoSAEBWSzJ64Ys3c8CB3Y2Y3a2ou0zgYDIn0vsA0qkzal8BrIAEyIBIAUGKEgBAYlk/f24x/gBg4TD+LMBxOS3jc/GVW3vxr0ufQJnn7o7ABEiASAHCChIAQE1YZ1ZGW8Ka5puyTeOnXK1Zks9ILXv8Kro/hydeDy5bwARIgEgCQoiASALDChIAQF1gubHSlu4HV48MX/PzGHNqSMoKA63hKdNjKUwaShSIgAOIgEgDQ4oSAEBJ3leLB8NJPObn8gcap7RL+Ci9K+agCW8iXQg8oAhMTAADiIBIA8QKEgBAfEVAT9hZOBmqXs5izJtPxT84qsHJEw1iRlTmbC6SE/bAA0oSAEB2MsL5GNPwYK6hkcUYg546TZIZMiUwp12WP96U4Vh/yoACyIBIBESKEgBAc20dnY3jjzARTunX07rhoAY3BCdf40B/PwDlxFAIvsaAAkiASATFCIBIBUWKEgBASxbcOA7VQnws4MxCDfCvH/AtFY63I6pxlaL+yBmNcdXAAgoSAEB2/Oz0tmZywtLxAE2QHFYGe3ZCQu+A2rg2rekuo6Ih6EABiIBIBcYIgEgGRooSAEBrmliBWZMVg0OshyprIQuRUKvQRc27t4Py/QFWSvisGEABiIBIBscKEgBAVC3u2c69J8y0/mVyRYRfQESE3IluOn3UjxTifCgR0mxAAUoSAEBOoCijWHkvrWJ56opXArUsypQiAqFlisc8e/1hI1vpwMAASIBIB0eKEgBAdpIemjNYsySQPQlrBxpc8uCP8qXIy+bgtowZdpOEVWrAAEiAWYfIChIAQFogUcNEcuvUxgAhxCLy7J01NEWpVFDLXpldmuiOw2z4wAAAF+7zXFbGHZdT+6JrPFw2Z/GNfUdvFHcW3ncnY5UMBQTIBV1KgAAA1M7LwgAA1OEFgSdFBq7";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = ForTonFrtSwapRequest.fromCell(body);

    expect(decoded.receiver).toEqual(address(RECEIVER));
    expect(decoded.routeAuthorization.hash()).toEqual(AUTHORIZATION_CELL_HASH);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
