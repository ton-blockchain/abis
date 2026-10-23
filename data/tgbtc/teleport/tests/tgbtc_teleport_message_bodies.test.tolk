import "@acton/fmt"
import "@acton/testing/expect"
import "../types/tgbtc_teleport.types"

get fun `test decodes teleport mint event`() {
    val body = parseCellFromBase64("te6cckEBAQEASgAAj3eoDvMgsigA46DqZKEIJftm78GinSaFJOwwJDNet/N+qryG73hYBg3Bmv3kGgjrqRfh2UUE7uS6jScuuv0s0/OIfePZE3r3n7ud8lw=");
    val decoded = TgbtcTeleportMintEvent.fromCell(body);

    expect(decoded.amount > 0).toBeTrue();
    expect(decoded.bitcoinTxid > 0).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes teleport new key event`() {
    val body = parseCellFromBase64("te6cckEBAQEASwAAkSd1ZykwdQkRynpXbvuBwPwVOiIRrcRxJJooC7A5mkkWIMaBe6Dy9ggAKY+PfU5F8QkarzLDGAPHL47+f56UGGrV02pMIJ+7ZJs2/Dj7");
    val decoded = TgbtcTeleportNewKeyEvent.fromCell(body);

    expect(
        decoded.newInternalPubkey,
    ).toEqual(0x1ca7a576efb81c0fc153a2211adc471249a280bb0399a491620c6817ba0f2f60);
    expect(decoded.pegoutAddress != null).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
