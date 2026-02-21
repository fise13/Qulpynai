//
//  LoyaltyRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct LoyaltyRepositoryImpl: LoyaltyRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchBalance(userId: String?) async throws -> LoyaltyAccount {
        let dto: LoyaltyAccountDTO = try await apiClient.request(.loyaltyBalance(userId: userId))
        return dto.toDomain()
    }

    func earnPoints(userId: String?, amount: Int) async throws {
        _ = try await apiClient.request(.loyaltyBalance(userId: userId))
    }

    func redeemPoints(userId: String?, amount: Int) async throws {
        _ = try await apiClient.request(.loyaltyBalance(userId: userId))
    }
}
