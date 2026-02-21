//
//  AddToCartUseCase.swift
//  Qulpynai
//

import Foundation

struct AddToCartUseCase {
    private let cartManager: CartManager

    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }

    func execute(product: Product, quantity: Int = 1) {
        cartManager.add(product, quantity: quantity)
    }
}
