//
//  FetchMenuUseCase.swift
//  Qulpynai
//
//  UseCase — Fetch menu
//

import Foundation

struct FetchMenuUseCase {
    private let menuRepository: MenuRepositoryProtocol

    init(menuRepository: MenuRepositoryProtocol) {
        self.menuRepository = menuRepository
    }

    func executeCategories(locationId: String? = nil) async throws -> [Category] {
        try await menuRepository.fetchCategories(locationId: locationId)
    }

    func executeProducts(categoryId: String? = nil, locationId: String? = nil) async throws -> [Product] {
        try await menuRepository.fetchProducts(categoryId: categoryId, locationId: locationId)
    }
}
