/// Tegro Finance DEX pool: GRAM/Jetton AMM pair accepting direct GRAM swaps and Jetton-forwarded swaps and liquidity.
contract TegroPool {
    author: "Tegro"
    version: "1.0"
    description: "Tegro Finance Pool holds one GRAM/Jetton pair, swaps GRAM sent with `swap_ton`, and reads swap and liquidity intents from Jetton transfer forward payloads."
    incomingMessages: TegroPoolIncomingMessage
    forceAbiExport: TegroPoolForwardPayload
}

/// Referrer address carried in a referenced cell.
struct TegroPoolReferrer {
    /// Referrer credited for the swap.
    referrerAddress: address?
}

/// GRAM to Jetton swap paid with the attached value.
struct (0x600c00fd) TegroPoolSwapTon {
    /// Query id of the swap.
    queryId: uint64
    /// Whether the input is taken exactly and the output is variable.
    extract: bool
    /// Maximum GRAM to spend.
    maxIn: coins
    /// Minimum Jetton amount to receive.
    minOut: coins
    /// Recipient of the Jettons.
    destination: address
    /// Recipient of the refund on failure.
    errorDestination: address
    /// Optional referrer.
    referrer: Cell<TegroPoolReferrer>?
}

/// Internal message bodies accepted by the pool.
type TegroPoolIncomingMessage = TegroPoolSwapTon

/// Liquidity provision intent carried as a Jetton transfer forward payload.
struct (0x287e167a) TegroPoolAddLiquidityForwardPayload {
    /// Amount of the first asset provided.
    amountA: coins
    /// Amount of the second asset provided.
    amountB: coins
}

/// Jetton to GRAM swap intent carried as a Jetton transfer forward payload.
struct (0x01fb7a25) TegroPoolJettonSwapForwardPayload {
    /// Whether the input is taken exactly and the output is variable.
    extract: bool
    /// Maximum Jetton amount to spend.
    maxIn: coins
    /// Minimum GRAM to receive.
    minOut: coins
    /// Recipient of the GRAM.
    destination: address
    /// Recipient of the refund on failure.
    errorDestination: address
    /// Optional payload forwarded with the output.
    payload: cell?
}

/// Forward payload variants read by the pool.
type TegroPoolForwardPayload =
    | TegroPoolAddLiquidityForwardPayload
    | TegroPoolJettonSwapForwardPayload
