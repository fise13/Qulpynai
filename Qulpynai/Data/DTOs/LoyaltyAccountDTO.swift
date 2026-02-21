//
//  LoyaltyAccountDTO.swift
//  Qulpynai
//

import Foundation

struct LoyaltyAccountDTO: Codable {
    let userId: String
    let balance: Int
    let pointsPerDollar: Int?
    let pointsUntilNextReward: Int?

    func toDomain() -> LoyaltyAccount {
        LoyaltyAccount(
            userId: userId,
            balance: balance,
            pointsPerDollar: pointsPerDollar ?? 10,
            pointsUntilNextReward: pointsUntilNextReward ?? 150,
            tier: .bronze
        )
    }
}
