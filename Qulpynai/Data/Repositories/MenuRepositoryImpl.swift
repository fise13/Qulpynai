//
//  MenuRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct MenuRepositoryImpl: MenuRepositoryProtocol {
    private let apiClient: APIClient
    private let adminStore: AdminStore?

    init(apiClient: APIClient, adminStore: AdminStore? = nil) {
        self.apiClient = apiClient
        self.adminStore = adminStore
    }

    func fetchCategories(locationId: String? = nil) async throws -> [Category] {
        if adminStore?.useAdminData == true {
            return adminStore!.domainCategories
        }
        let dtos: [CategoryDTO] = try await apiClient.request(.categories)
        return dtos.map { $0.toDomain() }
    }

    func fetchProducts(categoryId: String?, locationId: String? = nil) async throws -> [Product] {
        if adminStore?.useAdminData == true {
            let all = adminStore!.domainProducts
            guard let cid = categoryId, cid != "all" else { return all }
            return all.filter { $0.categoryId == cid }
        }
        let dtos: [ProductDTO] = try await apiClient.request(.products(categoryId: categoryId == "all" ? nil : categoryId))
        return dtos.map { $0.toDomain() }
    }
}
