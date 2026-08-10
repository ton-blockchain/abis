import "@acton/fmt"
import "@acton/testing/expect"
import "../types/wallet_v5r1.types"

get fun `test wallet v5r1 decodes STON.fi excess message`() {
    val body = parseCellFromBase64("te6cckEBAQEAXAAAs3bb0wYAJd5EhIBqHlVx4Cuz+t0qBAfSFqUQoBwzmnI8O+lS+UOqkzi3Vj3gdhxKQ6Tg+FtphoECgBq+HUH/RVNDBzuJHUaOgWH0paFMf5/O6jVtK+PgVnZcCGYcSlk=");
    val decoded = StonfiExcesses.fromCell(body);

    expect(decoded.payload.remainingBitsCount()).toEqual(684);
    expect(decoded.payload.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
