//
//  Product.swift
//  Qulpynai
//
//  Domain model — Product
//

import Foundation

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let nameKey: String
    let description: String
    let descriptionKey: String
    let price: Decimal
    let categoryId: String
    let imageURL: String?
    let placeholderIcon: String
    var isOutOfStock: Bool

    var priceFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
}
