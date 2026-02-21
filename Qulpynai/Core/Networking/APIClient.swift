//
//  APIClient.swift
//  Qulpynai
//
//  Networking protocol — easy switch mock/real
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func request(_ endpoint: APIEndpoint) async throws
}

enum APIEndpoint {
    case login(email: String, password: String)
    case register(email: String, password: String, name: String?)
    case logout
    case categories
    case products(categoryId: String?)
    case orders
    case createOrder(OrderDTO)
    case loyaltyBalance(userId: String?)
}

enum APIError: LocalizedError {
    case invalidURL
    case decodingFailed(Error?)
    case serverError(Int)
    case networkError(Error)
    case unauthorized
    case forbidden
    case notFound
    case validationError(Int, String?)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingFailed(let e): return e?.localizedDescription ?? "Failed to decode response"
        case .serverError(let code): return "Server error (\(code))"
        case .networkError(let error): return error.localizedDescription
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Access denied"
        case .notFound: return "Not found"
        case .validationError(let code, let msg): return msg ?? "Validation error (\(code))"
        }
    }

    static func from(statusCode: Int, data: Data? = nil) -> APIError {
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
