//
//  LoyaltyManager.swift
//  Qulpynai
//

import Foundation

@Observable
final class LoyaltyManager {
    private let loyaltyRepository: LoyaltyRepositoryProtocol
    private weak var appState: AppState?

    init(loyaltyRepository: LoyaltyRepositoryProtocol) {
        self.loyaltyRepository = loyaltyRepository
    }

    func inject(appState: AppState) {
        self.appState = appState
    }

    func fetchBalance(userId: String?) async throws -> LoyaltyAccount {
        try await loyaltyRepository.fetchBalance(userId: userId)
    }

    func earnPoints(userId: String?, amount: Int) async throws {
        try await loyaltyRepository.earnPoints(userId: userId, amount: amount)
    }

    func redeemPoints(userId: String?, amount: Int) async throws {
        try await loyaltyRepository.redeemPoints(userId: userId, amount: amount)
    }
}
