//
//  RealAPIClient.swift
//  Qulpynai
//
//  Real API client — token auth, status mapping
//

import Foundation

final class RealAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let tokenStore: TokenStore?

    init(baseURL: URL, session: URLSession = .shared, tokenStore: TokenStore? = nil) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStore = tokenStore
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let (data, response) = try await performRequest(endpoint)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    func request(_ endpoint: APIEndpoint) async throws {
        _ = try await performRequest(endpoint)
    }

    private func performRequest(_ endpoint: APIEndpoint) async throws -> (Data, URLResponse) {
        var request = try buildRequest(endpoint)
        if let token = tokenStore?.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }
        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.from(statusCode: http.statusCode, data: data)
        }
        return (data, response)
    }

    private func buildRequest(_ endpoint: APIEndpoint) throws -> URLRequest {
        let (path, method, body): (String, String, Data?)
        switch endpoint {
        case .login(let email, let password):
            (path, method, body) = ("/auth/login", "POST", try? JSONEncoder().encode(["email": email, "password": password]))
        case .register(let email, let password, let name):
            let payload = ["email": email, "password": password, "name": name ?? ""]
            (path, method, body) = ("/auth/register", "POST", try? JSONEncoder().encode(payload))
        case .logout:
            (path, method, body) = ("/auth/logout", "POST", nil)
        case .categories:
            (path, method, body) = ("/menu/categories", "GET", nil)
        case .products(let categoryId):
            let query = categoryId.map { "?categoryId=\($0)" } ?? ""
            (path, method, body) = ("/menu/products\(query)", "GET", nil)
        case .orders:
            (path, method, body) = ("/orders", "GET", nil)
        case .createOrder(let dto):
            (path, method, body) = ("/orders", "POST", try? JSONEncoder().encode(dto))
        case .loyaltyBalance(let userId):
            let query = userId.map { "?userId=\($0)" } ?? ""
            (path, method, body) = ("/loyalty/balance\(query)", "GET", nil)
        }
        let pathTrimmed = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = baseURL.appendingPathComponent(pathTrimmed)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
}
