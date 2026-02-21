//
//  AppState.swift
//  Qulpynai
//
//  Global app flow state — injected, no singleton
//

import Foundation

@Observable
final class AppState {
    var isAuthenticated: Bool = false
    var currentUser: User?
    var selectedLocation: Location?
    var activeOrder: Order?
    var loyaltyBalance: Int {
        didSet {
            UserDefaults.standard.set(loyaltyBalance, forKey: Self.loyaltyKey)
        }
    }

    private static let loyaltyKey = "qulpynai_loyalty_balance"

    init() {
        self.loyaltyBalance = UserDefaults.standard.integer(forKey: Self.loyaltyKey)
    }
}
