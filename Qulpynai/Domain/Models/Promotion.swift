//
//  Promotion.swift
//  Qulpynai
//
//  Domain model — Promo / discount
//

import Foundation

struct Promotion: Identifiable, Hashable {
    let id: String
    let code: String
    let type: PromotionType
    let value: Decimal
    let minOrderAmount: Decimal?
    let expiresAt: Date?

    enum PromotionType: String, Hashable {
        case percent
        case fixedAmount
        case freeItem
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Promotion, rhs: Promotion) -> Bool { lhs.id == rhs.id }
}
