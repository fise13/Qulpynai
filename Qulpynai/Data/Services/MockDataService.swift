//
//  MockDataService.swift
//  Qulpynai
//
//  Bridge for UI — provides static data when not using async
//

import Foundation

enum MockDataService {
    static var categories: [Category] {
        MockDataDTO.categories.map { $0.toDomain() }
    }

    static var products: [Product] {
        MockDataDTO.products(for: nil).map { $0.toDomain() }
    }

    static func products(categoryId: String) -> [Product] {
        MockDataDTO.products(for: categoryId == "all" ? nil : categoryId).map { $0.toDomain() }
    }

    static var orders: [Order] {
        MockDataDTO.orders.map { $0.toDomain() }
    }
}
