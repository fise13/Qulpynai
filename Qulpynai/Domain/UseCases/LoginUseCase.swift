//
//  LoginUseCase.swift
//  Qulpynai
//
//  UseCase — Login
//

import Foundation

struct LoginUseCase {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async throws -> User {
        try await authRepository.login(email: email, password: password)
    }
}
