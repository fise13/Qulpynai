//
//  RegisterUseCase.swift
//  Qulpynai
//

import Foundation

struct RegisterUseCase {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String, name: String?) async throws -> User {
        try await authRepository.register(email: email, password: password, name: name)
    }
}
