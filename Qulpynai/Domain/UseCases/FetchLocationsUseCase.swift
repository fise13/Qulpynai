//
//  FetchLocationsUseCase.swift
//  Qulpynai
//

import Foundation

struct FetchLocationsUseCase {
    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func execute() async throws -> [Location] {
        try await locationRepository.fetchLocations()
    }
}
