//
//  PersistenceStore.swift
//  Qulpynai
//
//  Persistence adapters — abstract UserDefaults
//

import Foundation

protocol KeyValueStore {
    func get<T: Decodable>(_ key: String) -> T?
    func set<T: Encodable>(_ value: T?, forKey key: String)
    func remove(key: String)
}

final class UserDefaultsStore: KeyValueStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func get<T: Decodable>(_ key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set<T: Encodable>(_ value: T?, forKey key: String) {
        if let value {
            if let data = try? JSONEncoder().encode(value) {
                defaults.set(data, forKey: key)
            }
        } else {
            defaults.removeObject(forKey: key)
        }
    }

    func remove(key: String) {
        defaults.removeObject(forKey: key)
    }
}
