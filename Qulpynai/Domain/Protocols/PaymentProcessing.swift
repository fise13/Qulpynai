//
//  PaymentProcessing.swift
//  Qulpynai
//
//  Payment port — Domain layer
//

import Foundation

protocol PaymentProcessing {
    func processPayment(
        amount: Decimal,
        paymentMethodId: String,
        orderId: String
    ) async throws -> PaymentResult
}

struct PaymentResult {
    let success: Bool
    let transactionId: String?
    let errorMessage: String?
}
