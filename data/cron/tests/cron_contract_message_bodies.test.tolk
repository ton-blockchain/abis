import "@acton/fmt"
import "@acton/testing/expect"
import "../types/cron_contract.types"

get fun `test decodes cron contract init body`() {
    val body = parseCellFromBase64("te6cckEBAQEABgAACC5B06zIaFFo");
    val decoded = CronContractInit.fromCell(body);

    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes cron contract notify body`() {
    val body = parseCellFromBase64("te6cckEBAQEAKAAAS9An7+X+GDkpPWKaDf+MeOxhpjbTysVqiuJt3n6D5/oWLSF/4wBgYUxPzg==");
    val decoded = CronContractNotify.fromCell(body);

    expect(
        decoded.initStateHash,
    ).toEqual(0xfe1839293d629a0dff8c78ec61a636d3cac56a8ae26dde7e83e7fa162d217fe3);
    expect(decoded.initStateDepth).toEqual(1);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes cron contract reward body`() {
    val body = parseCellFromBase64("te6cckEBAQEABgAACC4EiRqHj5x6");
    val decoded = CronContractReward.fromCell(body);

    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes cron contract destroyed body`() {
    val body = parseCellFromBase64("te6cckEBAQEABgAACLvieCHUwtrl");
    val decoded = CronContractDestroyed.fromCell(body);

    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test decodes cron contract trigger body`() {
    val body = parseCellFromBase64("te6cckEBAQEALAAAUyEUcC2ADEx6Hv7vk6JFFw3qswL4BGXkP6MPJLY9teXY3XBKh8/fQHr/8GETgH8=");
    val decoded = CronContractTrigger.fromCell(body);

    expect(decoded.rewardAddress).toEqual(
        address("0:6263D0F7F77C9D1228B86F559817C0232F21FD187925B1EDAF2EC6EB82543E7E"),
    );
    expect(decoded.salt).toEqual(4194555903);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
