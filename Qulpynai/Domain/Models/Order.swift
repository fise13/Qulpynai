//
//  Order.swift
//  Qulpynai
//
//  Domain model — Order
//

import Foundation

struct Order: Identifiable, Hashable {
    let id: String
    let orderNumber: String
    let date: Date
    let status: OrderStatus
    let items: [CartItem]
    let total: Decimal
    let userId: String?

    var totalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: total as NSDecimalNumber) ?? "$\(total)"
    }

    enum OrderStatus: String, Hashable {
        case pending
        case confirmed
        case preparing
        case ready
        case delivered
        case failed
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Order, rhs: Order) -> Bool { lhs.id == rhs.id }
}
