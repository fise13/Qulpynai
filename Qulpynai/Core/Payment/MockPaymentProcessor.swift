//
//  MockPaymentProcessor.swift
//  Qulpynai
//

import Foundation

final class MockPaymentProcessor: PaymentProcessor {
    private let delay: TimeInterval
    private let simulateFailure: Bool

    init(delay: TimeInterval = 0.5, simulateFailure: Bool = false) {
        self.delay = delay
        self.simulateFailure = simulateFailure
    }

    func processPayment(
        amount: Decimal,
        paymentMethodId: String,
        orderId: String
    ) async throws -> PaymentResult {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        if simulateFailure {
            return PaymentResult(
                success: false,
                transactionId: nil,
                errorMessage: "Simulated payment failure"
            )
        }
        return PaymentResult(
            success: true,
            transactionId: "tx_\(UUID().uuidString.prefix(8))",
            errorMessage: nil
        )
    }
}

