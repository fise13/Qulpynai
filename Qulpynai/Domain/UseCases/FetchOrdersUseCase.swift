//
//  FetchOrdersUseCase.swift
//  Qulpynai
//

import Foundation

struct FetchOrdersUseCase {
    private let orderRepository: OrderRepositoryProtocol

    init(orderRepository: OrderRepositoryProtocol) {
        self.orderRepository = orderRepository
    }

    func execute(userId: String? = nil) async throws -> [Order] {
        try await orderRepository.fetchOrders(userId: userId)
    }
}
