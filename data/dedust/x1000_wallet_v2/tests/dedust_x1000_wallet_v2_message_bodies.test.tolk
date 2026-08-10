import "@acton/fmt"
import "@acton/testing/expect"
import "../types/dedust_x1000_wallet_v2.types"

get fun `test DeDust x1000 Wallet V2 decodes a real signed external request`() {
    // External inbound body of transaction
    // 1d0aac90eae0914432710b859d6d4c6bb42aa36141f29fe00165cc240cc17a87.
    val bodyBoc = "te6cckECHgEAAmMAAa/MIr6L5m9INsvIIybocmxOduIBVVLl2FOubfhe/+nNUVelbMXLGluRJ7KWDqGZ4pU8E2Uvf8ltZ8Anwl1v2YMAAAAqvQAAABoAAAAAgAABgGS5jHlAk2FAAQNfgAXW5Qv7d51Hn+02RuXIZc4rfIN3KuDzmKXyD8j43XMDyg4iVyWGGpW8Vkj4qcMOAgMEAiOlp8v4UreKyR8VOGFQbncmvDgFBgIBbgcIAQNAExkAIcRCUA9w8Xt4dQyTAAam9XGRANOAALFjBkfPf49HmFzHHQ2hM2AzjS9qk3D/WVLJ2LZOyeoII8NGAEAAWLGDI+e/x6PMLmOOhtCZsBnGl7VJuH+sqWTsWydk9QAgACxYwZHz3+PR5hcxx0NoTNgM40vapNw/1lSydi2TsnqEAgFuCQoCAUgPEAIBWAsMAgFIDQ4AF6jLGEAAAADiKE/4sAAXqLNgQAAAAOIphZtQABeom6hAAAAA4kdG2dAAF6iD8EAAAADiKGVd0AAXrgeZCAAAABxEt+lGAgEgERIAF62s2BAAAAA4iWb/BAIBIBMUAgEgFRYCASAXGAAXqJuoQAAAAOJQPxHQABeog/BAAAAA4iib4NAAF6hsOEAAAADiJY5qsAAXqFSAQAAAAOIllVWQAgNBDRsaAQNBCRsCEHDxe3h1DJMAHB0AhYAAsWMGR89/j0eYXMcdDaEzYDONL2qTcP9ZUsnYtk7J6hAAFhar9OrXdKcwZVErI7SK1O1MCq0ScGUYCxmp7aqofLoAQ4AF1uUL+3edR5/tNkblyGXOK3yDdyrg85il8g/I+N1zA9AKA5Qf";
    val body = parseCellFromBase64(bodyBoc);
    val request = DedustX1000WalletV2SignedRequest.fromCell(body);

    expect(request.seqno).toEqual(10941);
    expect(request.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real execution request`() {
    // Outgoing message e9UfUJ+n7+qvmmF/H9DBmxDnWFZDlTGfWLGGM3Nk5GY=.
    val bodyBoc = "te6cckEBAQEADgAAGAEBAgFyz1b24dFP9m2QVa0=";
    val body = parseCellFromBase64(bodyBoc);
    val request = DedustX1000WalletV2ExecutionRequested.fromCell(body);

    expect(request.requestId).toEqual(0x72cf56f6e1d14ff6);
    expect(request.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real stored-message callback`() {
    // Incoming message Slc5bY5d48gbSFOG9WJg/fHWtYcZWzn2dWF7FHMhkKk=.
    val bodyBoc = "te6cckEBAQEADgAAGAEBAgJyz1b24dFP9kSc+rQ=";
    val body = parseCellFromBase64(bodyBoc);
    val callback = DedustX1000WalletV2ExecuteStoredMessage.fromCell(body);

    expect(callback.requestId).toEqual(0x72cf56f6e1d14ff6);
    expect(callback.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real Jetton transfer`() {
    // Outgoing message j3Y1eKf3qQd5YIpFK/rNo4YA9iVEwEcFhorgO34hWn0=.
    val bodyBoc = "te6cckEBAwEA/gABtg+KfqVWjEMAQKBrQnAdXe7jdkO4ALvt76z8/Rh1QLAgjAr2QtUsRzEs+uc4skr9PgOm2cqXAAFixgyPnv8ejzC5jjobQmbAZxpe1Sbh/rKlk7FsnZPUCDWk6QEBAeFmZN4qgAvDWJyINlcNyg7+HltsSw1DbL27gj+kOL8CgJfh019YkAAWLGDI+e/x6PMLmOOhtCZsBnGl7VJuH+sqWTsWydk9QgACxYwZHz3+PR5hcxx0NoTNgM40vapNw/1lSydi2TsnqAAAAAA1PPJdwAIAUwgACxYwZHz3+PR5hcxx0NoTNgM40vapNw/1lSydi2TsnqCAhYOwAAAAENVn5e4=";
    val body = parseCellFromBase64(bodyBoc);
    val transfer = DedustX1000WalletV2JettonTransfer.fromCell(body);

    expect(transfer.queryId).toEqual(0x568c430040a06b42);
    expect(transfer.amount).toEqual(516628432774203);
    expect(transfer.destination).toEqual(
        address("EQBd9vfWfn6MOqBYEEYFeyFqliOYln1znFklfp8B02zlS_Lq"),
    );
    expect(transfer.responseDestination).toBeNotNull();
    expect(transfer.responseDestination!).toEqual(
        address("EQAFixgyPnv8ejzC5jjobQmbAZxpe1Sbh_rKlk7FsnZPUFZn"),
    );
    expect(transfer.customPayload).toBeNull();
    expect(transfer.forwardAmount).toEqual(450000000);
    expect(transfer.forwardPayload).toBeNotNull();
    val swap = DedustX1000StonfiV2SwapPayload.fromCell(transfer.forwardPayload!);
    expect(swap.tokenWallet).toEqual(
        address("EQBeGsTkQbK4blB38PLbYlhqG2Xt3BH9IcX4FAS_Dpr6xPJK"),
    );
    expect(swap.refundAddress).toEqual(transfer.responseDestination!);
    expect(swap.excessAddress).toEqual(transfer.responseDestination!);
    expect(swap.deadline).toEqual(1786373307);
    val swapBody = swap.swapBody.load();
    expect(swapBody.minOut).toEqual(0);
    expect(swapBody.receiver).toBeNotNull();
    expect(swapBody.receiver!).toEqual(transfer.responseDestination!);
    expect(swapBody.forwardGas).toEqual(70000000);
    expect(swapBody.customPayload).toBeNull();
    expect(swapBody.refundForwardGas).toEqual(0);
    expect(swapBody.refundPayload).toBeNull();
    expect(swapBody.referralFee).toEqual(0);
    expect(swapBody.referralAddress).toBeNull();
    expect(transfer.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real StonksPump sell`() {
    // Outgoing message fS1gln435vHHPeH5xYS5/d+DyrKO9VRB8jaNoBNujvI=.
    val bodyBoc = "te6cckEBAQEAOAAAa8wal68jj2ZXkT+nT3A3uOL2d0doAAsWMGR89/j0eYXMcdDaEzYDONL2qTcP9ZUsnYtk7J6gEJrR3p0=";
    val body = parseCellFromBase64(bodyBoc);
    val sell = DedustX1000StonksPumpSell.fromCell(body);

    expect(sell.queryId).toEqual(0x238f6657913fa74f);
    expect(sell.amount).toEqual(980275541013622);
    expect(sell.proceedsRecipient).toBeNotNull();
    expect(sell.proceedsRecipient!).toEqual(
        address("EQAFixgyPnv8ejzC5jjobQmbAZxpe1Sbh_rKlk7FsnZPUFZn"),
    );
    expect(sell.minGramOut).toEqual(0);
    expect(sell.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real Uranus sell`() {
    // Outgoing message JQ3orO8gY371Q6LTnzlY80EJLp60iGHhfYqNYUK0+V8=.
    val bodyBoc = "te6cckEBAQEANwAAabdFnixqR6abPzszsWG2MrCRyQCAALFjBkfPf49HmFzHHQ2hM2AzjS9qk3D/WVLJ2LZOyeoESwJGTg==";
    val body = parseCellFromBase64(bodyBoc);
    val sell = DedustX1000UranusSell.fromCell(body);

    expect(sell.queryId).toEqual(0x6a47a69b3f3b33b1);
    expect(sell.amount).toEqual(30112737729680);
    expect(sell.minGramOut).toEqual(0);
    expect(sell.excessAddress).toBeNotNull();
    expect(sell.excessAddress!).toEqual(
        address("EQAFixgyPnv8ejzC5jjobQmbAZxpe1Sbh_rKlk7FsnZPUFZn"),
    );
    expect(sell.partner).toBeNull();
    expect(sell.referrer).toBeNull();
    expect(sell.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real 10937847 event`() {
    // Transaction 1d0aac90eae0914432710b859d6d4c6bb42aa36141f29fe00165cc240cc17a87.
    val bodyBoc = "te6cckEBAQEAEgAAIBCTeEdSt4rJHxU4YfKBJsJn1l5v";
    val body = parseCellFromBase64(bodyBoc);
    val event = DedustX1000WalletV2Event10937847.fromCell(body);

    expect(event.unknown0).toEqual(0x52b78ac91f153861);
    expect(event.unknown1).toEqual(0xf28126c2);
    expect(event.toCell().hash()).toEqual(body.hash());
}

get fun `test DeDust x1000 Wallet V2 decodes a real beaf9617 event`() {
    // Transaction 1aa1ddaf81a171d00a9ec74420259895db0e41e461f55f93455471fec6c29bf1.
    val bodyBoc = "te6ccgEBAQEADgAAGL6vlhdp/x/DhOrfaQ==";
    val body = parseCellFromBase64(bodyBoc);
    val event = DedustX1000WalletV2EventBeaf9617.fromCell(body);

    expect(event.unknown0).toEqual(0x69ff1fc384eadf69);
    expect(event.toCell().hash()).toEqual(body.hash());
}
