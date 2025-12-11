//
//  RecipesListView.swift
//  RecipesListUI
//
//  Created by Thomas Romay on 05/12/2025.
//

import Core
import CoreUI
import SwiftUI

@MainActor
struct RecipesListView: View {
    @StateObject var viewModel: RecipesListViewModel
    @State private var selectedRecipe: Recipe?

    var body: some View {
        NavigationStack {
            List {
                if !viewModel.favourites.isEmpty {
                    Section("Favourites") {
                        ForEach(viewModel.favourites) { recipe in
                            RecipeRow(recipe: recipe)
                                .onTapGesture { selectedRecipe = recipe }
                                .accessibilityHint("Open recipe details")
                        }
                    }
                }

                Section("All Recipes") {
                    ForEach(viewModel.recipes) { recipe in
                        RecipeRow(recipe: recipe)
                            .onTapGesture { selectedRecipe = recipe }
                            .accessibilityHint("Open recipe details")
                    }
                }
            }
            .navigationTitle("Recipes")
            .task { await viewModel.load() }
            .navigationDestination(item: $selectedRecipe) { recipe in
                RecipeDetailView(
                    viewModel: RecipeDetailViewModel(
                        recipe: recipe,
                        repository: viewModel.repository
                    )
                )
            }
        }
    }
}
