import "@acton/fmt"
import "@acton/testing/expect"
import "../types/comments.types"

get fun `test decodes plain text comment body`() {
    val body = parseCellFromBase64("te6cckEBAQEAKAAATAAAAAAxNDkgVGVsZWdyYW0gU3RhcnMgCgpSZWYja29uY2d6c3JTtTKw7g==");
    val decoded = TextComment.fromCell(body);
    var text = decoded.text;

    expect(text.remainingBitsCount()).toEqual(272);
    expect(text.remainingRefsCount()).toEqual(0);
    expect(text.loadUint(32)).toEqual(0x31343920);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes encrypted text comment body`() {
    val body = parseCellFromBase64("te6cckEBAgEAaQABTiFn2ksGB15//K3rSjdgM/y/hudtqyDz0SC5s4tkTAN/X2ua3mTQHwEAesuZg4GNrK+9+M5O46+78+D0CfAKmPgPw96sBYgw6dzzswMDzyaAgS7OK0+jVPIqtFcHpFeCVY/wQ5Bn8VSAysZJ");
    val decoded = EncryptedTextComment.fromCell(body);
    val cipherText = decoded.cipherText;

    expect(cipherText.remainingBitsCount()).toEqual(280);
    expect(cipherText.remainingRefsCount()).toEqual(1);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
