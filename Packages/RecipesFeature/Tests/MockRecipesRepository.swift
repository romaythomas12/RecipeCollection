//
//  MockRecipesRepository.swift
//  RecipesFeature
//
//  Created by Thomas Romay on 11/12/2025.
//

import Core
import CoreDB
import Foundation

final actor MockRecipesRepository: RecipesRepositoryProtocol {
    private var persistedRecipes: [PersistedRecipe]
    private var favouriteIDs: Set<Int>
    
    init(persistedRecipes: [PersistedRecipe] = [], favouriteIDs: Set<Int> = []) {
        self.persistedRecipes = persistedRecipes
        self.favouriteIDs = favouriteIDs
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        persistedRecipes.map { $0.toDomain() }
    }
    
    func getFavouriteRecipes() async -> [Recipe] {
        persistedRecipes
            .filter { favouriteIDs.contains($0.id) }
            .map { $0.toDomain() }
    }
    
    func toggleFavourite(id: Int) async {
        if favouriteIDs.contains(id) {
            favouriteIDs.remove(id)
        } else {
            favouriteIDs.insert(id)
        }
    }
    
    // MARK: - Helpers for tests
    
    func add(_ recipe: PersistedRecipe, markFavourite: Bool = false) async {
        persistedRecipes.append(recipe)
        if markFavourite {
            favouriteIDs.insert(recipe.id)
        }
    }
    
    func reset() async {
        persistedRecipes.removeAll()
        favouriteIDs.removeAll()
    }
}
