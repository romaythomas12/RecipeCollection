//
//  RecipesListViewModel.swift
//  RecipesListUI
//
//  Created by Thomas Romay on 05/12/2025.
//

import Core
import CoreUI
import SwiftUI

@MainActor
final class RecipesListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var favourites: [Recipe] = []
    
    let repository: RecipesRepositoryProtocol
    
    init(repository: RecipesRepositoryProtocol) {
        self.repository = repository
    }
    
    func load() async {
        do {
            self.recipes = try await repository.fetchRecipes()
            self.favourites = await repository.getFavouriteRecipes()
        } catch {
            print("Error loading recipes: \(error)")
        }
    }
    
    func toggleFavourite(recipe: Recipe) async {
        await repository.toggleFavourite(id: recipe.id)
        if favourites.contains(where: { $0.id == recipe.id }) {
            favourites.removeAll(where: { $0.id == recipe.id })
        } else {
            favourites.append(recipe)
        }
    }
}
