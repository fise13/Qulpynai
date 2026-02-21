//
//  ApplePayPaymentProcessor.swift
//  Qulpynai
//
//  Placeholder for future Apple Pay integration — merchant ID from config
//

import Foundation

final class ApplePayPaymentProcessor: PaymentProcessor {
    private let merchantId: String

    init(merchantId: String) {
        self.merchantId = merchantId
    }

    func processPayment(
        amount: Decimal,
        paymentMethodId: String,
        orderId: String
    ) async throws -> PaymentResult {
        // TODO: Implement Apple Pay with PKPaymentAuthorizationController
        // Use merchantId for PKPaymentRequest.merchantIdentifier
        _ = merchantId
        throw APIError.networkError(NSError(domain: "Payment", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple Pay not implemented"]))
    }
}
