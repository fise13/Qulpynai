//
//  OrderRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct OrderRepositoryImpl: OrderRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchOrders(userId: String?) async throws -> [Order] {
        let dtos: [OrderDTO] = try await apiClient.request(.orders)
        return dtos.map { $0.toDomain() }
    }

    func createOrder(_ order: Order) async throws -> Order {
        let dto = OrderDTO(
            id: order.id,
            orderNumber: order.orderNumber,
            date: order.date,
            status: order.status.rawValue,
            items: order.items.map { CartItemDTO(id: $0.id, product: ProductDTO(from: $0.product), quantity: $0.quantity) },
            total: order.total,
            userId: order.userId
        )
        let result: OrderDTO = try await apiClient.request(.createOrder(dto))
        return result.toDomain()
    }
}
