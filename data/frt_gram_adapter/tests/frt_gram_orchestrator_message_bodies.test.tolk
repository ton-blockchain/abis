import "@acton/fmt"
import "@acton/testing/expect"
import "../types/frt_gram_orchestrator.types"

// Message bodies from mainnet trace 342e6948e4bdf520e18cf54991545b4d58d88872ed58f5128198c52e90199b37,
// pinned to blocks 83536149-83536151.

const ROUTE_DESTINATION = "EQCcSVxmNtWGfJ3lcNXU93YgDIHuAMcTlJBMBbx-NTjFq3rp"
const COORDINATOR = "EQAOYIpqiuS0blDySfqSPKHhYoJRRV8RxUHGQUw_hw8WUQth"

get fun `test frt gram orchestrator decodes real worker route state`() {
    // Outgoing body from transaction k1Eqgwvj5mMsAmjhXX/XYv3l/CT+ZO1j7KNdQTfiDA4= at LT 94153320000017.
    val bodyBoc = "te6cckEBAQEALQAAVZofDwMAACSTgAqc1o8/KzB+VpaTKslWYVXN39tYr3tJMjHMmzwL7nSHYEivB4ii";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorWorkerRouteState.fromCell(body);

    expect(decoded.sequence).toEqual(9363);
    expect(decoded.destination).toEqual(
        address("EQBU5rR5-VmD8rS0mVZKswqubv7axXvaSZGOZNngX3OkO5rt"),
    );
    expect(decoded.action).toEqual(2);
    expect(decoded.state).toBeNull();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram orchestrator decodes real route registration`() {
    // Outgoing body from transaction k1Eqgwvj5mMsAmjhXX/XYv3l/CT+ZO1j7KNdQTfiDA4= at LT 94153320000017.
    val bodyBoc = "te6cckEBAQEADQAAFZofDAgAAwAAJJPABgTubg==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorRouteRegistration.fromCell(body);

    expect(decoded.routeIndex).toEqual(3);
    expect(decoded.sequence).toEqual(9363);
    expect(decoded.notifySuccess).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram orchestrator decodes real work request`() {
    val bodyBoc = "te6cckEBAQEALQAAVZofDwwAAAFaBoATiSuMxtqwz5O8rhq6nu7EAZA9wBjicpIJgLePxqcYtXiL+EIF";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorWorkRequest.fromCell(body);

    expect(decoded.sequence).toEqual(346);
    expect(decoded.step).toEqual(6);
    expect(decoded.destination).toEqual(address(ROUTE_DESTINATION));
    expect(decoded.enabled).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram orchestrator decodes real worker dispatch`() {
    val bodyBoc = "te6cckEBAQEAMQAAXpofDw4AAAFaUBYqXLgIATiSuMxtqwz5O8rhq6nu7EAZA9wBjicpIJgLePxqcYtX/QqK+A==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorWorkerDispatch.fromCell(body);

    expect(decoded.sequence).toEqual(346);
    expect(decoded.amount).toEqual(5950000000);
    expect(decoded.destination).toEqual(address(ROUTE_DESTINATION));
    expect(decoded.enabled).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram orchestrator decodes real worker result`() {
    val bodyBoc = "te6cckEBAQEAVQAApZofDw8ABwAAAVpQFipcuAgBOJK4zG2rDPk7yuGrqe7sQBkD3AGOJykgmAt4/Gpxi1cAA5gimqK5LRuUPJJ+pI8oeFiglFFXxHFQcZBTD+HDxZRwI2ynig==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorWorkerResult.fromCell(body);

    expect(decoded.routeIndex).toEqual(7);
    expect(decoded.sequence).toEqual(346);
    expect(decoded.amount).toEqual(5950000000);
    expect(decoded.workerAddress).toEqual(address(ROUTE_DESTINATION));
    expect(decoded.destination).toEqual(address(COORDINATOR));
    expect(decoded.enabled).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram orchestrator decodes real continuation`() {
    val bodyBoc = "te6cckEBAQEAWQAArZofDxtJUC+QAAA1AWKly4CAAcwRTVFclo3KHkk/UkeUPCxQSiir4jioOMgph/Dh4sowAnElcZjbVhnyd5XDV1Pd2IAyB7gDHE5SQTAW8fjU4xasAAAFa6dfokk=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramOrchestratorContinuation.fromCell(body);

    expect(decoded.amount).toEqual(2500000000);
    expect(decoded.routeIndex).toEqual(3);
    expect(decoded.reserve).toEqual(5950000000);
    expect(decoded.destination).toEqual(address(COORDINATOR));
    expect(decoded.payload.remainingBitsCount()).toEqual(300);
    expect(decoded.payload.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
