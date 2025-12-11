//
//  RecipesRemoteServiceProtocol.swift
//  Core
//
//  Created by Thomas Romay on 10/12/2025.
//

import Foundation

public protocol RecipesRemoteServiceProtocol: Sendable {
    func fetchRecipes(
        from: Int,
        size: Int,
        tags: String
    ) async throws -> [Recipe]
}
