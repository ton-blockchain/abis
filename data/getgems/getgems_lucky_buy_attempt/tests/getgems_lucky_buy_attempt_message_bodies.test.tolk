import "@acton/fmt"
import "@acton/io"
import "@acton/testing/expect"
import "../types/getgems_lucky_buy_attempt.types"

get fun `test Getgems Lucky Buy attempt decodes real start body`() {
    val txHash = "3qlO0SLwhmLz7WOYnjoYRdtbczTKP6o/pycOpIFgaAE=";
    val bodyBoc = "te6cckEBAQEADgAAGLfjCj52pIbusLxNSTG0+jM=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = GetgemsLuckyBuyStart.fromCell(body);

    expect(decoded.attemptId).toEqual(0x76a486eeb0bc4d49);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("GETGEMS_LUCKY_BUY_FUND_TX={}", txHash);
}

get fun `test Getgems Lucky Buy attempt decodes real signed resolution`() {
    val txHash = "S7Ow330wMlfkL569CQuKQ+f62ebLn0CkVOGoUUaE0wU=";
    val bodyBoc = "te6cckEBAgEA1QAB22/CcWJOAWrN+wX0rEj32iXwfem3O47seOnlDELBBtCTBhxK7s7Wvzo6oBFenYLyFaQ3lpHjzRplwuQt57Z4tQGam9XlSAB0B/C7YF2FWE7j9cx0T1Cost14lwGHkFmaKaYI4seQFS0N4GhlHWAgAQDEQgB2+XpcOJx8WnL++L6GJ8neEtUAklv8OQQaww7cfIp5/QAAAAAAAAAAAAAAAAAAAAAAAEx1Y2t5IEJ1eTogWW91IGxvc3Qgb24gZ2V0Z2Vtcy5pbyAoMjklIGNoYW5jZSm3VDin";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = GetgemsLuckyBuyResolve.fromCell(body);

    expect(decoded.action).toEqual(2);
    expect(decoded.validUntil).toEqual(1785681813);
    expect(decoded.requestNonce).toEqual(2306353319023313270);
    expect(
        decoded.nftItemAddressHash,
    ).toEqual(0x15613b8fd731d13d42a2cb75e25c061e416668a698238b1e4054b43781a19475);
    var actions = decoded.actions;
    expect(actions.loadUint(8)).toEqual(128);
    val message = actions.loadRef();
    expect(
        message.hash(),
    ).toEqual(0x8eb6ec5fb7927dba98b10a8d8a11657a084a8ea8e8692bf537ce367202b7a98c);
    expect(actions.remainingBitsCount()).toEqual(0);
    expect(actions.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
    println("GETGEMS_LUCKY_BUY_EXECUTE_TX={}", txHash);
}
