import "@acton/fmt"
import "@acton/testing/expect"
import "../types/dns_renewal_top_upper.types"

get fun `test decodes dns renewal top-upper calc and topup body`() {
    val body = parseCellFromBase64("te6cckEBBgEAxgABeVb2EQ5o06syAAFRgGjSWbI0xLQIANmiFZIb/ED6Pc7vuf+HlWppIxKsQEtdD3aasXcuyP8AgEB36Aaq5gEBAgoOw8htAwIDAgoOw8htAwQFAG5iADfuAr/a4Re8c71ymvx45Q3h6X1woGm2oHvwr71ddLFmmmJaAAAAAAAAAAAAAAAAAAAAAAAAAAAAbmIAG21sHszcBB+WsBm18/hNPPYIZwa8/5m9wfK06a3ShjcaYloAAAAAAAAAAAAAAAAAAAAAAADfYEYi");
    val decoded = DnsRenewalTopUpperCalcAndTopup.fromCell(body);

    expect(decoded.firstCallTime).toEqual(1758702386);
    expect(decoded.repeatEvery).toEqual(86400);
    expect(decoded.salt).toEqual(1758615986);
    expect(decoded.reward).toEqual(5000000);
    expect(decoded.ownerAddress).toEqual(
        address("EQBs0QrJDf4gfR7nd9z_w8q1NJGJViAlroe7TVi7l2R_gBkv"),
    );
    expect(decoded.topupAmount).toEqual(33800000);
    expect(decoded.msgToWalletAmount).toEqual(5600000);
    expect(decoded.toCell().hash()).toEqual(body.hash());

    val actions = DnsRenewalTopUpperOutActionWithSendMessageOnly.fromCell(
        decoded.renewalActionsCell,
    );
    expect(actions.sendMode).toEqual(3);
    expect(actions.toCell().hash()).toEqual(decoded.renewalActionsCell.hash());
}
