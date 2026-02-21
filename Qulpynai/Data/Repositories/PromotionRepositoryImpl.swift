//
//  PromotionRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct PromotionRepositoryImpl: PromotionRepositoryProtocol {
    func fetchPromotion(code: String) async throws -> Promotion? {
        // Mock: Single promo code for MVP
        guard code.uppercased() == "WELCOME10" else { return nil }
        return Promotion(
            id: "p1",
            code: "WELCOME10",
            type: .percent,
            value: 10,
            minOrderAmount: 15,
            expiresAt: nil
        )
    }

    func validatePromotion(_ promotion: Promotion, cartTotal: Decimal) -> Bool {
        if let min = promotion.minOrderAmount, cartTotal < min { return false }
        if let expiry = promotion.expiresAt, Date() > expiry { return false }
        return true
    }
}
