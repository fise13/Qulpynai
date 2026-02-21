//
//  CartManager.swift
//  Qulpynai
//
//  Cart state — injected, no singleton
//

import Foundation
import SwiftUI

@Observable
final class CartManager {
    var items: [CartItem] = []
    var isCartPresented: Bool = false
    var isCheckoutPresented: Bool = false
    var appliedPromotion: Promotion?
    var discountAmount: Decimal = 0

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Decimal {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var total: Decimal {
        max(0, subtotal - discountAmount)
    }

    var totalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: total as NSDecimalNumber) ?? "$\(total)"
    }

    func add(_ product: Product, quantity: Int = 1, customization: ProductCustomization? = nil) {
        let c = customization?.isEmpty == true ? nil : customization
        if let index = items.firstIndex(where: { $0.matches(productId: product.id, customization: c) }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(
                id: UUID().uuidString,
                product: product,
                quantity: quantity,
                customization: c
            ))
        }
    }

    func updateQuantity(for itemId: String, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        if quantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = quantity
        }
    }

    func remove(_ itemId: String) {
        items.removeAll { $0.id == itemId }
    }

    func clear() {
        items.removeAll()
        appliedPromotion = nil
        discountAmount = 0
    }

    func applyPromotion(_ promotion: Promotion?, discount: Decimal) {
        appliedPromotion = promotion
        discountAmount = discount
    }
}
