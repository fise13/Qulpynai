//
//  FetchLoyaltyBalanceUseCase.swift
//  Qulpynai
//

import Foundation

struct FetchLoyaltyBalanceUseCase {
    private let loyaltyRepository: LoyaltyRepositoryProtocol

    init(loyaltyRepository: LoyaltyRepositoryProtocol) {
        self.loyaltyRepository = loyaltyRepository
    }

    func execute(userId: String? = nil) async throws -> LoyaltyAccount {
        try await loyaltyRepository.fetchBalance(userId: userId)
    }
}
