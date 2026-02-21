//
//  PromotionRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct PromotionRepositoryImpl: PromotionRepositoryProtocol {
    private let adminStore: AdminStore?

    init(adminStore: AdminStore? = nil) {
        self.adminStore = adminStore
    }

    func fetchPromotion(code: String) async throws -> Promotion? {
        if let promo = adminStore?.promotion(for: code) {
            return promo
        }
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
