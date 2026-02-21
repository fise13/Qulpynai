//
//  AppError.swift
//  Qulpynai
//

import Foundation

enum AppError: LocalizedError {
    case network(Error)
    case decoding
    case unauthorized
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network(let error): return error.localizedDescription
        case .decoding: return "Failed to load data"
        case .unauthorized: return "Please sign in"
        case .unknown(let msg): return msg
        }
    }
}
