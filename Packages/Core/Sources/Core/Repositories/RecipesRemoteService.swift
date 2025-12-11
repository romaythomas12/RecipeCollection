//
//  RecipeRepository.swift
//  Core
//
//  Created by Thomas Romay on 05/12/2025.
//

import Foundation

// MARK: - Network Protocols

public protocol NetworkSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSessionProtocol {}

public enum NetworkError: Error {
    case urlError
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodeError(Error)
}

// MARK: - Recipes Remote Service

public actor RecipesRemoteService: RecipesRemoteServiceProtocol {
    private let session: NetworkSessionProtocol
    private let host: String
    private let apiKey: String

    public init(
        session: NetworkSessionProtocol = URLSession.shared,
        host: String = "tasty.p.rapidapi.com",
        apiKey: String = "e4587ceb1emsh453429846496e6fp167489jsn95f197d275d3"
    ) {
        self.session = session
        self.host = host
        self.apiKey = apiKey
    }

    private func makeRequest(from: Int, size: Int, tags: String) throws -> URLRequest {
        let apiRequest = try APIRequestBuilder(host: host)
            .setPath("/recipes/list")
            .addQueryItem(name: "from", value: "\(from)")
            .addQueryItem(name: "size", value: "\(size)")
            .addQueryItem(name: "tags", value: tags)
            .setMethod("GET")
            .addHeader(name: "x-rapidapi-key", value: apiKey)
            .addHeader(name: "x-rapidapi-host", value: host)
            .addHeader(name: "Accept", value: "application/json")
            .build()
        return URLRequest(apiRequest: apiRequest)
    }

    public func fetchRecipes(
        from: Int = 0,
        size: Int = 20,
        tags: String = "under_30_minutes"
    ) async throws -> [Recipe] {
        let request = try makeRequest(from: from, size: size, tags: tags)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200 ..< 300).contains(http.statusCode) else {
            throw NetworkError.statusCode(http.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let list = try decoder.decode(TastyListResponse.self, from: data)
            return list.results.map { $0.toDomain() }
        } catch {
            throw NetworkError.decodeError(error)
        }
    }
}
