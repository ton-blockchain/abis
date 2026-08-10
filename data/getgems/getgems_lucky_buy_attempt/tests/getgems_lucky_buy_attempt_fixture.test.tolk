import "@acton/build"
import "@acton/fmt"
import "@acton/fs"
import "@acton/testing/expect"
import "../types/getgems_lucky_buy_attempt.types"

const CODE_PATH = "data/getgems/getgems_lucky_buy_attempt/testdata/GetgemsLuckyBuyAttempt.boc"
const DATA_PATH = "data/getgems/getgems_lucky_buy_attempt/testdata/GetgemsLuckyBuyAttempt.data.boc"
const CODE_HASH = 0x9785ed5ee1f07c1dedb5850eb6824d706f14769fec9a8a8a8462c3af1e10bd1d
const DATA_HASH = 0xb77067779957da0d4c7a11b991aadbd3e7166a4bb7c3072401e7cdb4d60a0156

get fun `test Getgems Lucky Buy attempt parses saved mainnet storage`() {
    val codeBytes = fs.readBytes(CODE_PATH);
    val dataBytes = fs.readBytes(DATA_PATH);
    expect(codeBytes).toBeNotNull();
    expect(dataBytes).toBeNotNull();
    expect(codeBytes!.preloadUint(32)).toEqual(0xb5ee9c72);
    expect(dataBytes!.preloadUint(32)).toEqual(0xb5ee9c72);

    val code = build("GetgemsLuckyBuyAttempt", CODE_PATH);
    val data = build("GetgemsLuckyBuyAttemptData", DATA_PATH);
    expect(code.hash()).toEqual(CODE_HASH);
    expect(data.hash()).toEqual(DATA_HASH);

    val storage = GetgemsLuckyBuyAttemptStorage.fromCell(data);
    val config = storage.config.load();
    expect(storage.state).toEqual(2);
    expect(storage.fundedValue).toEqual(1705925000);
    expect(storage.fundingAddress).toBeNotNull();
    expect(storage.fundingAddress!).toEqual(
        address("EQBpKrZIO_9A0BjtRpKLmE96CyYyZ8sP5Zwb0vIqrMNZk4jr"),
    );
    expect(storage.fundedAt).toEqual(1785681780);
    expect(storage.attemptId).toEqual(0x76a486eeb0bc4d49);
    expect(
        config.decisionPublicKey,
    ).toEqual(0x5020b03a705f1913b1d0e9c19e1571b3e7d448a9094fa162ca1be3c2b498fd55);
    expect(config.participantAddress).toEqual(
        address("EQBU3iLq4NaUTmrVuhmQ1E0Ud_PEQhmrhPLbm1p1qrUMKqKR"),
    );
    expect(config.marketplaceAddress).toEqual(
        address("EQBYTuYbLf8INxFtD8tQeNk5ZLy-nAX9ahQbG_yl1qQ-GEMS"),
    );
    expect(config.requestNonce).toEqual(2306353319023313270);
    expect(config.nftItemAddress.load()).toEqual(
        address("EQCoT_FmezVE4ItUp0LzX-Ss5juI6FsHR3xYVN_guvremtAv"),
    );
}

get fun `test Getgems Lucky Buy attempt parses real deployment state`() {
    val stateInitBoc = "te6cckECDQEAAnUAAgE0AQIBFP8A9KQT9LzyyAsDARoAAAAAAAAAAAAAAAAACwIBIAQFAgFIBgcC9PLtRNDTAfoA+lDTH9M/1NEg0NP/+kgx+kgx0z/U0QmDCNcYINMB0x/TP9P/+CNQBLvy4TYBgQweB7oW8vSBDB0N+QAVuhzy9IEMHwrAARry9IEMICrAApF/lSrAA8MA4vL0CMjO+RZQgvkQ8qMmwALjAjUFwAPjAl8FCQoB4tAz0NMD+kgwAXKwwACOEWwhyM+FCPpScM8LbsmAQvsA4CLXLCW/GFH0jjIz7UTQ0wH6ADH6UDHTHzHTPzHU0QHy0ZP4IwTXCz/Iz4WAUAT6AhL6VBPLH8s/zMntVOBsEtcsITboiOzjAluEDwHHAPL0CACNofSb2omhpgP0AfShpj+mf6mi2kPwVZGfCBAn9Kjhnha/mZIDkZ8JoZmZ8i2RnxQAgZf/nqHwUY4L5cDRoaf/9JH0kaZ/qaMAUDLtRNDXTNDT/zH6SDH6SNM/MdQx0QGBD78CxwXy9NdM0NMH10wB+wAATDb4AMjPhoBQBPoCEvpUyx/LPxLMye1UkyDXSpjTB9QCcrH7AOgwAFD4AMjPh4BQA/oCUhD6VBLLHxPLP8zJ7VTIz4UI+lJwzwtuyYEAgvsAAdVQILA6cF8ZE7HQ6cGeFXGz59RIqQlPoWLKG+PCtJj9VYAKm8RdXBrSic1at0MyGomijv54iEM1cJ5bc2tOtVahhVABYTuYbLf8INxFtD8tQeNk5ZLy+nAX9ahQbG/yl1qQ+GCAB0B/C7YF2gwAQ4AVCf4sz2aonBFqlOhea/yVnMdxHQtg6O+LCpv8F19b01BtI5ok";
    val stateInit = StateInit.fromCell(parseCellFromBase64(stateInitBoc));
    expect(stateInit.code).toBeNotNull();
    expect(stateInit.data).toBeNotNull();
    expect(stateInit.code!.hash()).toEqual(CODE_HASH);

    val storage = GetgemsLuckyBuyAttemptStorage.fromCell(stateInit.data!);
    val config = storage.config.load();
    expect(storage.state).toEqual(0);
    expect(storage.fundedValue).toEqual(0);
    expect(storage.fundingAddress).toBeNull();
    expect(storage.fundedAt).toEqual(0);
    expect(storage.attemptId).toEqual(0);
    expect(config.marketplaceAddress).toEqual(
        address("EQBYTuYbLf8INxFtD8tQeNk5ZLy-nAX9ahQbG_yl1qQ-GEMS"),
    );

    val deployedAddress = AutoDeployAddress {
        stateInit: ContractState {
            code: stateInit.code!,
            data: stateInit.data!,
        },
    }.calculateAddress();
    expect(deployedAddress).toEqual(
        address("EQBlQMPG12ktUZkXBudHs5TtFPySBkSk9VJcJjq_bWB2qVb-"),
    );
}
