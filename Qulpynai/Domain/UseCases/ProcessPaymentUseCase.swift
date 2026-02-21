//
//  ProcessPaymentUseCase.swift
//  Qulpynai
//

import Foundation

struct ProcessPaymentUseCase {
    private let paymentProcessor: PaymentProcessing

    init(paymentProcessor: PaymentProcessing) {
        self.paymentProcessor = paymentProcessor
    }

    func execute(amount: Decimal, paymentMethodId: String, orderId: String) async throws -> PaymentResult {
        try await paymentProcessor.processPayment(
            amount: amount,
            paymentMethodId: paymentMethodId,
            orderId: orderId
        )
    }
}
