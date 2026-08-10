import "@acton/fmt"
import "@acton/io"
import "@acton/testing/expect"
import "../types/storage_aggregate_contract.types"

get fun `test storage aggregate contract decodes live proof storage body`() {
    val txHash = "qvGhYLbNW4pNeJJiWCzpAddQlPKZgkGIZBFqGPwUmYQ=";
    val txLt = "45824124000003";
    val bodyBoc = "te6cckECGQEAAokAAehI9UjOAAAAAAAAAADNG9JI5Ia3RGoUHsLjeUkjWqIClB8Az4ngUJloQC4c8Ds9jXfT37tfA45zoy7MITBF1LO2i1oics/+mtW4MZUNUQ0wAA9Hs1n/+2cl9dSPfsAcqZAWDFF7g0eX6D8aNg48Pc9ttoOjvgEJRgMdNbpBXO2kTMLfVZwHAzzIEy9IZdB3cwP7ACFOwdbTEgALAiIAAwQiAAUGKEgBAc7bhbyT2s90nYhAtDWBlX9L8/vk1RRSnBoStVbcYP9yAAoiAAcIKEgBAU3BESCG4LO5vLWDqEeHHaVoNfsW4uB6ulW98Ig+0F14AAkoSAEBpVoHSn+tjGS4K6tjM9/1dYDc6LNq3OAeknoKyAkSw6cACCIACQooSAEBh+4O95Ah/vWX1c9meI85zk0l8o8fMcyXBuGK4yOhNgMAByIACwwoSAEBopedCHML7z+2pS3qtN+NvulBw2czkzVETZXupBJO8dUABiIADQ4oSAEB00WPqAMs6HPjvsaEMWrurG+dsj9j8Y91laLaTpSJQuQABSIADxAoSAEBfOM162JJ9VpuPonDrJV3+8Iz7AD4AY5Qzm3yFYZOX3AABCIAERIiABMUKEgBAaTlUVXPEC6TCTWp+kDEpx50wVBvAeDj4/YLI6FZ56dLAAMiABUWKEgBAQa/AtymhtGkcxpGQFQE8UuyFVyIk0RAbOV57Ua8gQRnAAICABcYKEgBAeOT9cnibK8SIUnkpM8ijerKjBt6osbiC7mhrH7hleLsAAEAQNrQPhK66FgeA4nW1/8Di/S6zAdB+zEiwoappAvBiWZiAEA5gumGiI3AAJjad98sOrjHRK+vXs9bRx0EQILqT+JGGXOHSEM=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = StorageAggregateProofStorage.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.key).toEqual(0xcd1bd248e486b7446a141ec2e37949235aa202941f00cf89e0509968402e1cf0);
    expect(decoded.nonce).toEqual(4340853685975491518);
    expect(
        decoded.proof.hash(),
    ).toEqual(0x60b10b689b49249c4fce00d26e8f85f12b9472582f3baea1aa6562d7596650f4);
    expect(decoded.toCell().hash()).toEqual(body.hash());

    println("STORAGE_AGGREGATE_PROOF_TX={} LT={}", txHash, txLt);
}

get fun `test storage aggregate contract decodes live reward withdrawal body`() {
    val txHash = "qvGhYLbNW4pNeJJiWCzpAddQlPKZgkGIZBFqGPwUmYQ=";
    val txLt = "45824124000003";
    val bodyBoc = "te6cckEBAQEADgAAGKkbr1YAAAAAAAAAAObdTSs=";
    val body = parseCellFromBase64(bodyBoc);
    val decoded = StorageAggregateRewardWithdrawal.fromCell(body);

    expect(decoded.queryId).toEqual(0);
    expect(decoded.toCell().hash()).toEqual(body.hash());

    println("STORAGE_AGGREGATE_REWARD_WITHDRAWAL_TX={} LT={}", txHash, txLt);
}
