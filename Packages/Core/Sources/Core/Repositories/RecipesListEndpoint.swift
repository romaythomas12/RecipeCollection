//
//  RecipesListEndpoint.swift
//  Core
//
//  Created by Thomas Romay on 11/12/2025.
//

import Foundation

public struct RecipesListEndpoint: Endpoint {
    let from: Int
    let size: Int
    let tags: String
    let apiKey: String

    public var path: String { "/recipes/list" }
    public var host: String { "tasty.p.rapidapi.com" }
    public var method: HTTPMethod { .get }

    public var headers: [String: String] {
        [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": host,
            "Accept": "application/json"
        ]
    }

    public var queryItems: [URLQueryItem] {
        [
            .init(name: "from", value: "\(from)"),
            .init(name: "size", value: "\(size)"),
            .init(name: "tags", value: tags)
        ]
    }
}
