import "@acton/fmt"
import "@acton/testing/expect"
import "../types/tgbtc_coordinator.types"

get fun `test decodes coordinator dkg completed event`() {
    val body = parseCellFromBase64("te6cckEBAQEALgAAWEU0Q6YAAAAAaUk2fRynpXbvuBwPwVOiIRrcRxJJooC7A5mkkWIMaBe6Dy9gtA99lw==");
    val decoded = TgbtcCoordinatorDkgCompletedEvent.fromCell(body);

    expect(decoded.timestamp).toEqual(0x6949367d);
    expect(
        decoded.internalPubkey,
    ).toEqual(0x1ca7a576efb81c0fc153a2211adc471249a280bb0399a491620c6817ba0f2f60);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
