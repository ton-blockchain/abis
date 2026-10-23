import "@acton/fmt"
import "@acton/testing/expect"
import "../types/dedust_operator_v2.types"

get fun `test decodes operator forward`() {
    val body = parseCellFromBase64("te6cckEBAgEAYQABW/GYklUAAAAAAAAAAIAf+FRjG+xBrDc6SCs00D9mz5FAyrG6ix2TspW2UWhv9xABAFsmxjq3AAAAAAAAAACABmzJ8wJ8F/sm1iZmbF3rdSW/gWwCsjSsEV0ZrfC2AdaQuPVGcw==");
    val decoded = DedustOperatorV2Forward.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.destination).toEqual(
        address("0:FFC2A318DF620D61B9D24159A681FB367C8A06558DD458EC9D94ADB28B437FB8"),
    );
    expect(decoded.body.beginParse().loadUint(32)).toEqual(0x26c63ab7);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes operator collect fees`() {
    val body = parseCellFromBase64("te6cckEBAQEAVgAAqAtCn1IAAAAAAAAAAESbuX+YAGbMnzAnwX+ybWJmZsXet1Jb+BbAKyNKwRXRmt8LYB1oCABmzJ8wJ8F/sm1iZmbF3rdSW/gWwCsjSsEV0ZrfC2AdaDcc8Hc=");
    val decoded = DedustOperatorV2CollectFees.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.asset0Payload).toBeNull();
    expect(decoded.asset1Payload).toBeNull();
    expect(decoded.asset0Destination).toEqual(decoded.asset1Destination!);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes operator configure start time`() {
    val body = parseCellFromBase64("te6cckEBAQEAEgAAIH7X9s4AAAAAAAAAAGkEstAZJuEG");
    val decoded = DedustOperatorV2ConfigureStartTime.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.startAt).toEqual(1761915600);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
