//
//  UpdateCartItemUseCase.swift
//  Qulpynai
//

import Foundation

struct UpdateCartItemUseCase {
    private let cartManager: CartManager

    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }

    func execute(itemId: String, quantity: Int) {
        cartManager.updateQuantity(for: itemId, quantity: quantity)
    }
}
