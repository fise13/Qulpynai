//
//  TokenStore.swift
//  Qulpynai
//
//  Secure token storage — Keychain-backed
//

import Foundation

protocol TokenStore {
    func getAccessToken() -> String?
    func setAccessToken(_ token: String?)
    func getRefreshToken() -> String?
    func setRefreshToken(_ token: String?)
    func clear()
}

final class KeychainTokenStore: TokenStore {
    private let accessKey = "qulpynai_access_token"
    private let refreshKey = "qulpynai_refresh_token"
    private let service = "wise.Qulpynai"

    func getAccessToken() -> String? {
        read(key: accessKey)
    }

    func setAccessToken(_ token: String?) {
        if let token {
            write(key: accessKey, value: token)
        } else {
            delete(key: accessKey)
        }
    }

    func getRefreshToken() -> String? {
        read(key: refreshKey)
    }

    func setRefreshToken(_ token: String?) {
        if let token {
            write(key: refreshKey, value: token)
        } else {
            delete(key: refreshKey)
        }
    }

    func clear() {
        delete(key: accessKey)
        delete(key: refreshKey)
    }

    private func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }

    private func write(key: String, value: String) {
        delete(key: key)
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
