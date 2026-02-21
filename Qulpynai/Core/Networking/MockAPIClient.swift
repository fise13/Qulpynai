//
//  MockAPIClient.swift
//  Qulpynai
//
//  Mock API — simulates network, delay, errors
//

import Foundation

final class MockAPIClient: APIClient {
    private let delay: TimeInterval
    private var shouldFailNext: Bool = false

    init(delay: TimeInterval = 0.5) {
        self.delay = delay
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        try await simulateDelay()
        let result: Any = try handleEndpoint(endpoint)
        return result as! T
    }

    func request(_ endpoint: APIEndpoint) async throws {
        try await simulateDelay()
    }

    private func simulateDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }

    private func handleEndpoint(_ endpoint: APIEndpoint) throws -> Any {
        switch endpoint {
        case .login(let email, let password):
            if email.isEmpty || password.count < 4 {
                throw APIError.unauthorized
            }
            let user = UserDTO(id: UUID().uuidString, email: email, name: "User")
            return user

        case .register(let email, let password, let name):
            if email.isEmpty || password.count < 4 {
                throw APIError.unauthorized
            }
            let user = UserDTO(id: UUID().uuidString, email: email, name: name ?? "User")
            return user

        case .logout:
            return [String: String]()

        case .categories:
            return MockDataDTO.categories

        case .products(let categoryId):
            let products = categoryId.map { MockDataDTO.products(for: $0) } ?? MockDataDTO.allProducts
            return products

        case .orders:
            return [] as [OrderDTO]

        case .createOrder(let dto):
            let order = OrderDTO(
                id: UUID().uuidString,
                orderNumber: "#\(Int.random(in: 1000...9999))",
                date: Date(),
                status: "confirmed",
                items: dto.items,
                total: dto.total,
                userId: dto.userId
            )
            return order

        case .loyaltyBalance:
            return LoyaltyAccountDTO(userId: "mock", balance: 1250, pointsPerDollar: 10, pointsUntilNextReward: 150)
        }
    }
}
