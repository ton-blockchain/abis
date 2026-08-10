import "@acton/fmt"
import "@acton/testing/expect"
import "../types/frt_gram_coordinator.types"

// Message bodies from mainnet trace 342e6948e4bdf520e18cf54991545b4d58d88872ed58f5128198c52e90199b37,
// pinned to blocks 83536149-83536151.

const ROUTE_DESTINATION = "EQCcSVxmNtWGfJ3lcNXU93YgDIHuAMcTlJBMBbx-NTjFq3rp"
const VALUE_REQUESTER = "EQCwjhQdCRwLWC5VFCWi5dVvS7Y42w0eyoGEmIiok1Ed1m01"

get fun `test frt gram coordinator decodes real route registration`() {
    // Outgoing body from transaction k1Eqgwvj5mMsAmjhXX/XYv3l/CT+ZO1j7KNdQTfiDA4= at LT 94153320000017.
    val bodyBoc = "te6cckEBAQEADQAAFZofDAgAAwAAJJPABgTubg==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramCoordinatorRouteRegistration.fromCell(body);

    expect(decoded.routeIndex).toEqual(3);
    expect(decoded.sequence).toEqual(9363);
    expect(decoded.notifySuccess).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram coordinator decodes real route request`() {
    val bodyBoc = "te6cckEBAQEADQAAFpofDAkAAwAAAVoGH27VwQ==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramCoordinatorRouteRequest.fromCell(body);

    expect(decoded.routeIndex).toEqual(3);
    expect(decoded.sequence).toEqual(346);
    expect(decoded.action).toEqual(6);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram coordinator decodes real dispatch`() {
    val bodyBoc = "te6cckEBAQEAVQAApZofDAoAAwAAAVoGgBOJK4zG2rDPk7yuGrqe7sQBkD3AGOJykgmAt4/Gpxi1aSoF8gEAJxJXGY21YZ8neVw1dT3diAMge4AxxOUkEwFvH41OMWrwWLA9LA==";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramCoordinatorDispatch.fromCell(body);

    expect(decoded.routeIndex).toEqual(3);
    expect(decoded.sequence).toEqual(346);
    expect(decoded.action).toEqual(6);
    expect(decoded.destination).toEqual(address(ROUTE_DESTINATION));
    expect(decoded.amount).toEqual(2500000000);
    expect(decoded.responseAddress).toEqual(address(ROUTE_DESTINATION));
    expect(decoded.callbackEnabled).toBeTrue();
    expect(decoded.payload.remainingBitsCount()).toEqual(0);
    expect(decoded.payload.remainingRefsCount()).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram coordinator decodes real completion callback`() {
    val bodyBoc = "te6cckEBAQEACwAAEZofDA2gwv+1VEFSkEA=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = FrtGramCoordinatorCallback.fromCell(body);

    expect(decoded.success).toBeTrue();
    expect(decoded.amount).toEqual(408942250);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram coordinator decodes real value request`() {
    val body = parseCellFromBase64("te6cckEBAQEACwAAEZofDAxA7hBqKB1/rLY=");
    val decoded = FrtGramCoordinatorValueRequest.fromCell(body);

    expect(decoded.amount).toEqual(249628322);
    expect(decoded.toCell().hash()).toEqual(body.hash());
}

get fun `test frt gram coordinator decodes real value dispatch`() {
    val body = parseCellFromBase64("te6cckEBAQEAUgAAn5ofDA5A7hBqKAFhHCg6EjgWsFyqKEtFy6rel2xxtho9lQMJMRFRJqI7rJKgXyAQAsI4UHQkcC1guVRQlouXVb0u2ONsNHsqBhJiIqJNRHdbgnYHow==");
    val decoded = FrtGramCoordinatorValueDispatch.fromCell(body);

    expect(decoded.requestedAmount).toEqual(249628322);
    expect(decoded.requester).toEqual(address(VALUE_REQUESTER));
    expect(decoded.configuredAmount).toEqual(2500000000);
    expect(decoded.responseAddress).toEqual(address(VALUE_REQUESTER));
    expect(decoded.enabled).toBeTrue();
    expect(decoded.toCell().hash()).toEqual(body.hash());
}
