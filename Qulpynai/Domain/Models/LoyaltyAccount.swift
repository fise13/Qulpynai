//
//  LoyaltyAccount.swift
//  Qulpynai
//
//  Domain model — LoyaltyAccount
//

import Foundation

struct LoyaltyAccount {
    let userId: String
    var balance: Int
    let pointsPerDollar: Int
    let pointsUntilNextReward: Int
    let tier: LoyaltyTier

    enum LoyaltyTier: String {
        case bronze
        case silver
        case gold
    }
}
