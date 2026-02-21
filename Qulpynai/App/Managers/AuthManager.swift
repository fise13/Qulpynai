//
//  AuthManager.swift
//  Qulpynai
//

import Foundation

@Observable
final class AuthManager {
    private let authRepository: AuthRepositoryProtocol
    private let appState: AppState
    private let tokenStore: TokenStore?
    private let sessionKey = "qulpynai_user_session"

    init(authRepository: AuthRepositoryProtocol, appState: AppState, tokenStore: TokenStore? = nil) {
        self.authRepository = authRepository
        self.appState = appState
        self.tokenStore = tokenStore
    }

    func login(email: String, password: String) async throws {
        let user = try await authRepository.login(email: email, password: password)
        await MainActor.run {
            appState.currentUser = user
            appState.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
        saveSession(user: user)
    }

    func register(email: String, password: String, name: String?) async throws {
        let user = try await authRepository.register(email: email, password: password, name: name)
        await MainActor.run {
            appState.currentUser = user
            appState.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
        saveSession(user: user)
    }

    func logout() {
        appState.currentUser = nil
        appState.isAuthenticated = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: sessionKey)
        tokenStore?.clear()
    }

    func restoreSession() {
        guard let data = UserDefaults.standard.data(forKey: sessionKey),
              let session = try? JSONDecoder().decode(SessionData.self, from: data) else { return }
        appState.currentUser = User(id: session.userId, email: session.email, name: session.name)
        appState.isAuthenticated = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }

    private func saveSession(user: User) {
        let session = SessionData(userId: user.id, email: user.email, name: user.name)
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: sessionKey)
        }
    }
}

private struct SessionData: Codable {
    let userId: String
    let email: String
    let name: String?
}
