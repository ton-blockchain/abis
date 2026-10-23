import "@acton/fmt"
import "@acton/testing/expect"
import "../types/smart_account.types"

get fun `test decodes smart account change hot key external`() {
    val body = parseCellFromBase64("te6cckEBAgEAmgABmDTS6fkAAAAAAAAAAJVVg0KuRMafUEbxfCidXjb7UGabikmEzhlnbuJNpoD2EBstu03+0fi+wGQQxDCrrGCNKMY8TqjAeSNMDNAOhQQBAJH///zT9vQlAClLxBCyT10fhNlVCnhyXUkYPWYl/nQBxswNbestQw34MDf215CtLjOu794/XS0ajOYGuWfb/QBdmb7GP2848iigvxozUA==");
    val decoded = StormChangeHotKey.fromCell(body);
    val payload = decoded.signedPayload.load();

    expect(decoded.queryId).toEqual(0);
    expect(payload.saAddress).toEqual(
        address("0:A52F1042C93D747E13655429E1C9752460F59897F9D0071B3035B7ACB50C37E0"),
    );
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes smart account native self deposit external`() {
    val body = parseCellFromBase64("te6cckEBAgEAqQABmFWOgEr+NzM283CYeDpnLGP8XCzHn/bkaWkikxYXF0gz40JNx183zwVXJtfwKoqEEba/UciuWzYPzZ0xqcqkzQPlq2uBof/HC55ivgQBAK//sczVU8yxABzxVwm6/3yudP31flr7ogs1CoXW9LFhQD7HDabgoXsLP43MzbzcJh4UBMgvHQIAdJM7J/npOWOe71wbS64qkOAS1rRzyM0ShKcW8YzEAvjAuqepgA==");
    val decoded = StormSelfDepositNative.fromCell(body);
    val payload = decoded.signedPayload.load();

    expect(payload.saAddress).toEqual(
        address("0:73C55C26EBFDF2B9D3F7D5F96BEE882CD42A175BD2C58500FB1C369B8285EC2C"),
    );
    expect(payload.amount > 0).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes smart account jetton self deposit external`() {
    val body = parseCellFromBase64("te6cckEBAwEAzAABmAHYHrymDYsrXBU6Jgp0Qk/OGK+4BEBvfe5LphkPLhskZk+AwYB2az+1DQy7kkxLN0ioCw5tHVOdShn2Txqzs/QpD19tZxXcMplsjA0BAav/sczVPT4hABkWUzWsusuvW6+BkYYGpm614VZggJzP7rPOyaYH7b4HKYNiytcFTomMCLxiABn09Ca+X3/4aR2crDqhBx0PZcFxILSV9E4/UV6TuLW7wAIAQ4ATdcgZPbtqfVE5as9bePA+veurgVXHSgJ5pMM5sE2MZdCgNF89");
    val decoded = StormSelfDepositJetton.fromCell(body);
    val payload = decoded.signedPayload.load();

    expect(payload.saAddress).toEqual(
        address("0:64594CD6B2EB2EBD6EBE0646181A99BAD785598202733FBACF3B26981FB6F81C"),
    );
    expect(payload.amount > 0).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
