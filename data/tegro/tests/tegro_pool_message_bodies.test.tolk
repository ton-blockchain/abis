import "@acton/fmt"
import "@acton/testing/expect"
import "../types/tegro_pool.types"

get fun `test decodes tegro pool swap ton`() {
    val body = parseCellFromBase64("te6cckEBAQEAXAAAtGAMAP0LsuAoKTdwACQQT6QDYt7UkQ+RQAY06v5emqVnlGMjhEBk2XrnFPAPl1C5zm+3tlsNxY0+uADGnV/L01Ss8oxkcIgMmy9c4p4B8uoXOc329sthuLGn1uD7QNM=");
    val decoded = TegroPoolSwapTon.fromCell(body);

    expect(decoded.destination).toEqual(
        address("0:634EAFE5E9AA567946323844064D97AE714F00F9750B9CE6FB7B65B0DC58D3EB"),
    );
    expect(decoded.errorDestination).toEqual(decoded.destination);
    expect(decoded.referrer).toBeNull();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
