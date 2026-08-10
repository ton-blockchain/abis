/// Stateless proxy observed dispatching GRAM payments for Fragment checkout orders.
contract FragmentCheckoutPaymentProxy {
    author: "Unknown"
    description: "Dispatches referenced raw payments from Fragment checkout batches."
    storage: FragmentCheckoutPaymentProxyStorage
    incomingMessages: FragmentCheckoutPaymentProxyIncomingMessage
}

/// Empty persistent data used by the stateless payment proxy.
struct FragmentCheckoutPaymentProxyStorage {}

/// Observed Fragment checkout envelope for one batch of raw payments.
struct (0x6889303c) FragmentCheckoutPaymentBatch {
    /// Opaque 64-bit value ignored by the proxy and inferred to identify the checkout request.
    requestId: uint64
    /// Ordered 8-bit send modes, each followed by one referenced raw internal message.
    actions: RemainingBitsAndRefs
}

/// Observed internal message envelope accepted by the Fragment checkout payment proxy.
type FragmentCheckoutPaymentProxyIncomingMessage = FragmentCheckoutPaymentBatch
