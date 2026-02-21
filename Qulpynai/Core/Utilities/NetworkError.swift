//
//  NetworkError.swift
//  Qulpynai
//
//  Centralized network error mapping
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case decodingFailed(Error)
    case unauthorized
    case forbidden
    case notFound
    case validationError(Int, String?)
    case serverError(Int)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingFailed(let e): return "Decode failed: \(e.localizedDescription)"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Access denied"
        case .notFound: return "Not found"
        case .validationError(let code, let msg): return msg ?? "Validation error (\(code))"
        case .serverError(let code): return "Server error (\(code))"
        case .networkError(let e): return e.localizedDescription
        }
    }

    static func from(statusCode: Int, data: Data? = nil) -> NetworkError {
        switch statusCode {
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 400...499: return .validationError(statusCode, messageFrom(data: data))
        case 500...599: return .serverError(statusCode)
        default: return .serverError(statusCode)
        }
    }

    private static func messageFrom(data: Data?) -> String? {
        guard let data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let message = json["message"] as? String ?? json["error"] as? String else { return nil }
        return message
    }
}
