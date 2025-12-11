//
//  RecipeDetailViewModel.swift
//  RecipeDetailUI
//
//  Created by Thomas Romay on 09/12/2025.
//

import Combine
import Core
import Foundation

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe
    @Published private(set) var isFavourite: Bool = false

    private let repository: any RecipesRepositoryProtocol

    init(recipe: Recipe, repository: any RecipesRepositoryProtocol) {
        self.recipe = recipe
        self.repository = repository
        Task {
            await initialize()
        }
    }

    func initialize() async {
        let favourites = await repository.getFavouriteRecipes()
        self.isFavourite = favourites.contains { $0.id == recipe.id }
    }

    func toggleFavourite() async {
        await repository.toggleFavourite(id: recipe.id)
        isFavourite.toggle()
    }
}
