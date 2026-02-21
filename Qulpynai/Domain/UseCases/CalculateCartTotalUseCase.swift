//
//  CalculateCartTotalUseCase.swift
//  Qulpynai
//

import Foundation

struct CalculateCartTotalUseCase {
    private let cartManager: CartManager

    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }

    func execute() -> Decimal {
        cartManager.total
    }
}
