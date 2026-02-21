//
//  ApplyPromotionUseCase.swift
//  Qulpynai
//

import Foundation

struct ApplyPromotionUseCase {
    private let promotionRepository: PromotionRepositoryProtocol

    init(promotionRepository: PromotionRepositoryProtocol) {
        self.promotionRepository = promotionRepository
    }

    func execute(code: String, cartTotal: Decimal) async throws -> Promotion? {
        guard let promotion = try await promotionRepository.fetchPromotion(code: code) else { return nil }
        guard promotionRepository.validatePromotion(promotion, cartTotal: cartTotal) else { return nil }
        return promotion
    }

    func calculateDiscount(promotion: Promotion, cartTotal: Decimal) -> Decimal {
        switch promotion.type {
        case .percent:
            return cartTotal * (promotion.value / 100)
        case .fixedAmount:
            return min(promotion.value, cartTotal)
        case .freeItem:
            return 0
        }
    }
}
