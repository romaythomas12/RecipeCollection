//
//  RecipesFactoryProtocol.swift
//  RecipesListUI
//
//  Created by Thomas Romay on 09/12/2025.
//

import Core
import SwiftUI

public protocol RecipesFactoryProtocol {
    var repository: RecipesRepositoryProtocol { get }

    @MainActor
    func makeRecipesListView() -> AnyView

    @MainActor
    func makeRecipeDetailView(_ recipe: Recipe) -> AnyView
}

public final class RecipesFactory: RecipesFactoryProtocol {
    public let repository: RecipesRepositoryProtocol

    public init(repository: RecipesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    public func makeRecipesListView() -> AnyView {
        let vm = RecipesListViewModel(repository: repository)
        return AnyView(RecipesListView(viewModel: vm))
    }

    @MainActor
    public func makeRecipeDetailView(_ recipe: Recipe) -> AnyView {
        let vm = RecipeDetailViewModel(recipe: recipe, repository: repository)
        return AnyView(RecipeDetailView(viewModel: vm))
    }
}
