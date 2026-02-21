//
//  RepositoryProtocols.swift
//  Qulpynai
//
//  Repository contracts — Domain layer
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String, name: String?) async throws -> User
    func logout() async throws
}

protocol MenuRepositoryProtocol {
    func fetchCategories(locationId: String?) async throws -> [Category]
    func fetchProducts(categoryId: String?, locationId: String?) async throws -> [Product]
}

protocol LocationRepositoryProtocol {
    func fetchLocations() async throws -> [Location]
}

protocol OrderRepositoryProtocol {
    func fetchOrders(userId: String?) async throws -> [Order]
    func createOrder(_ order: Order) async throws -> Order
}

protocol LoyaltyRepositoryProtocol {
    func fetchBalance(userId: String?) async throws -> LoyaltyAccount
    func earnPoints(userId: String?, amount: Int) async throws
    func redeemPoints(userId: String?, amount: Int) async throws
}

protocol PromotionRepositoryProtocol {
    func fetchPromotion(code: String) async throws -> Promotion?
    func validatePromotion(_ promotion: Promotion, cartTotal: Decimal) -> Bool
}
