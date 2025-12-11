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
    private let session: any NetworkSessionProtocol
    private let apiKey: String
    private let requestBuilder: RequestBuilder

    public init(
        session: any NetworkSessionProtocol = URLSession.shared,
        apiKey: String,
        requestBuilder: RequestBuilder = RequestBuilder()
    ) {
        self.session = session
        self.apiKey = apiKey
        self.requestBuilder = requestBuilder
    }

    public func fetchRecipes(
        from: Int = 0,
        size: Int = 20,
        tags: String = "under_30_minutes"
    ) async throws -> [Recipe] {
        let endpoint = RecipesListEndpoint(
            from: from,
            size: size,
            tags: tags,
            apiKey: apiKey
        )

        let request = try requestBuilder.build(from: endpoint).urlRequest

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
