//
//  LocationRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct LocationRepositoryImpl: LocationRepositoryProtocol {
    private let apiClient: APIClient
    private let adminStore: AdminStore?

    init(apiClient: APIClient, adminStore: AdminStore? = nil) {
        self.apiClient = apiClient
        self.adminStore = adminStore
    }

    func fetchLocations() async throws -> [Location] {
        if adminStore?.useAdminData == true {
            return adminStore!.domainLocations
        }
        return [
            Location(id: "1", name: "Downtown", address: "123 Main St", latitude: nil, longitude: nil, isOpen: true),
            Location(id: "2", name: "Mall", address: "456 Mall Dr", latitude: nil, longitude: nil, isOpen: true)
        ]
    }
}
