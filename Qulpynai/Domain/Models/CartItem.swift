//
//  CartItem.swift
//  Qulpynai
//
//  Domain model — CartItem (with optional customization)
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id: String
    let product: Product
    var quantity: Int
    var customization: ProductCustomization?

    var unitPrice: Decimal {
        let base = product.price
        guard let c = customization else { return base }
        let mod = CustomizationOptions.priceModifier(
            size: c.size,
            milk: c.milk,
            extras: c.extras
        )
        return base + mod
    }

    var subtotal: Decimal { unitPrice * Decimal(quantity) }
    var subtotalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: subtotal as NSDecimalNumber) ?? "$\(subtotal)"
    }

    /// Same product + same customization = can merge quantity
    func matches(productId: String, customization: ProductCustomization?) -> Bool {
        product.id == productId && Self.customizationEqual(self.customization, customization)
    }

    private static func customizationEqual(_ a: ProductCustomization?, _ b: ProductCustomization?) -> Bool {
        switch (a, b) {
        case (nil, nil): return true
        case (nil, let b?): return b.isEmpty
        case (let a?, nil): return a.isEmpty
        case (let a?, let b?):
            return a.size == b.size && a.milk == b.milk
                && Set(a.extras) == Set(b.extras) && a.notes == b.notes
        }
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: CartItem, rhs: CartItem) -> Bool { lhs.id == rhs.id }
}
