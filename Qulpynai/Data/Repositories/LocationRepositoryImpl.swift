//
//  LocationRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct LocationRepositoryImpl: LocationRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchLocations() async throws -> [Location] {
        // Placeholder: Mock data until API supports locations
        return [
            Location(id: "1", name: "Downtown", address: "123 Main St", latitude: nil, longitude: nil, isOpen: true),
            Location(id: "2", name: "Mall", address: "456 Mall Dr", latitude: nil, longitude: nil, isOpen: true)
        ]
    }
}
