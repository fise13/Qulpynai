//
//  OrderManager.swift
//  Qulpynai
//

import Foundation

@Observable
final class OrderManager {
    private let orderRepository: OrderRepositoryProtocol
    private let paymentProcessor: PaymentProcessor
    private let loyaltyRepository: LoyaltyRepositoryProtocol
    private weak var appState: AppState?
    private weak var cartManager: CartManager?
    private let ordersKey = "qulpynai_order_history"

    init(
        orderRepository: OrderRepositoryProtocol,
        paymentProcessor: PaymentProcessor,
        loyaltyRepository: LoyaltyRepositoryProtocol
    ) {
        self.orderRepository = orderRepository
        self.paymentProcessor = paymentProcessor
        self.loyaltyRepository = loyaltyRepository
    }

    func inject(appState: AppState, cartManager: CartManager) {
        self.appState = appState
        self.cartManager = cartManager
    }

    func createOrder(
        from items: [CartItem],
        total: Decimal,
        deliveryOption: DeliveryOption,
        address: String,
        paymentMethodId: String,
        userId: String?
    ) async throws -> Order {
        guard !items.isEmpty else {
            throw OrderError.emptyCart
        }
        let orderId = UUID().uuidString
        let orderNumber = "#\(Int.random(in: 1000...9999))"

        let result = try await paymentProcessor.processPayment(
            amount: total,
            paymentMethodId: paymentMethodId,
            orderId: orderId
        )

        guard result.success else {
            throw OrderError.paymentFailed(result.errorMessage ?? "Payment failed")
        }

        let order = Order(
            id: orderId,
            orderNumber: orderNumber,
            date: Date(),
            status: .confirmed,
            items: items,
            total: total,
            userId: userId
        )

        var orders = loadOrderHistory()
        orders.insert(order, at: 0)
        saveOrderHistory(orders)

        await MainActor.run {
            appState?.activeOrder = order
            appState?.loyaltyBalance += Int(truncating: total as NSNumber) * 10
            cartManager?.clear()
        }

        return order
    }

    func fetchOrderHistory() async throws -> [Order] {
        let orders = loadOrderHistory()
        if !orders.isEmpty { return orders }
        let remote = try await orderRepository.fetchOrders(userId: appState?.currentUser?.id)
        saveOrderHistory(remote)
        return remote
    }

    private func loadOrderHistory() -> [Order] {
        guard let data = UserDefaults.standard.data(forKey: ordersKey),
              let dtos = try? JSONDecoder().decode([OrderDTO].self, from: data) else {
            return []
        }
        return dtos.map { $0.toDomain() }
    }

    private func saveOrderHistory(_ orders: [Order]) {
        let dtos = orders.map { order in
            OrderDTO(
                id: order.id,
                orderNumber: order.orderNumber,
                date: order.date,
                status: order.status.rawValue,
                items: order.items.map { item in
                    CartItemDTO(
                        id: item.id,
                        product: ProductDTO(from: item.product),
                        quantity: item.quantity,
                        customizationDTO: item.customization.map { ProductCustomizationDTO(from: $0) }
                    )
                },
                total: order.total,
                userId: order.userId
            )
        }
        if let data = try? JSONEncoder().encode(dtos) {
            UserDefaults.standard.set(data, forKey: ordersKey)
        }
    }
}

enum OrderError: LocalizedError {
    case emptyCart
    case paymentFailed(String)

    var errorDescription: String? {
        switch self {
        case .emptyCart: return "Cart is empty"
        case .paymentFailed(let msg): return msg
        }
    }
}
