//
//  AuthRepositoryImpl.swift
//  Qulpynai
//

import Foundation

struct AuthRepositoryImpl: AuthRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func login(email: String, password: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.login(email: email, password: password))
        return dto.toDomain()
    }

    func register(email: String, password: String, name: String?) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.register(email: email, password: password, name: name))
        return dto.toDomain()
    }

    func logout() async throws {
        try await apiClient.request(.logout)
    }
}
