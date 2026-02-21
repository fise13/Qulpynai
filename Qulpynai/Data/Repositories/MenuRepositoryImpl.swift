//
//  MenuRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct MenuRepositoryImpl: MenuRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchCategories(locationId: String? = nil) async throws -> [Category] {
        let dtos: [CategoryDTO] = try await apiClient.request(.categories)
        return dtos.map { $0.toDomain() }
    }

    func fetchProducts(categoryId: String?, locationId: String? = nil) async throws -> [Product] {
        let dtos: [ProductDTO] = try await apiClient.request(.products(categoryId: categoryId == "all" ? nil : categoryId))
        return dtos.map { $0.toDomain() }
    }
}
