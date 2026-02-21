//
//  CreateOrderUseCase.swift
//  Qulpynai
//

import Foundation

struct CreateOrderUseCase {
    private let orderManager: OrderManager
    private let cartManager: CartManager

    init(orderManager: OrderManager, cartManager: CartManager) {
        self.orderManager = orderManager
        self.cartManager = cartManager
    }

    func execute(
        deliveryOption: DeliveryOption,
        address: String,
        paymentMethodId: String,
        userId: String? = nil
    ) async throws -> Order {
        try await orderManager.createOrder(
            from: cartManager.items,
            total: cartManager.total,
            deliveryOption: deliveryOption,
            address: address,
            paymentMethodId: paymentMethodId,
            userId: userId
        )
    }
}

enum DeliveryOption {
    case delivery
    case pickup
}
