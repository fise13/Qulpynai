//
//  RemoveFromCartUseCase.swift
//  Qulpynai
//

import Foundation

struct RemoveFromCartUseCase {
    private let cartManager: CartManager

    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }

    func execute(productId: String) {
        cartManager.remove(productId)
    }
}
