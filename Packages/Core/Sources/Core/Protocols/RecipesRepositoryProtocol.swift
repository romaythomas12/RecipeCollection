//
//  RecipeRepositoryProtocol.swift
//  Core
//
//  Created by Thomas Romay on 05/12/2025.
//

import Foundation

public protocol RecipesRepositoryProtocol: Sendable {
    func fetchRecipes() async throws -> [Recipe]
    func getFavouriteRecipes() async -> [Recipe]
    func toggleFavourite(id: Int) async
}
