//
//  RecipesFeatureTests.swift
//  RecipesFeature
//
//  Created by Thomas Romay on 11/12/2025.
//

import Core
import CoreDB
import Foundation
@testable import RecipesFeature
import XCTest

@MainActor
final class RecipesFeatureTests: XCTestCase {
    var repository: MockRecipesRepository!
    var sampleRecipe: Recipe!
    var samplePersisted: PersistedRecipe!

    override func setUp() async throws {
        repository = MockRecipesRepository()

        // Sample domain and persisted recipe
        sampleRecipe = Recipe(
            id: 1,
            name: "Pizza",
            description: "Delicious cheese pizza",
            thumbnailURL: "https://example.com/pizza.png",
            videoURL: nil,
            servings: 2,
            totalTimeMinutes: 30,
            ratingScore: 4.5,
            ingredients: [
                IngredientItem(id: 1, name: "Cheese", rawText: "200g cheese"),
                IngredientItem(id: 2, name: "Dough", rawText: "500g dough")
            ],
            instructions: [
                InstructionItem(id: 1, text: "Roll the dough", position: 1),
                InstructionItem(id: 2, text: "Add cheese", position: 2)
            ]
        )

        samplePersisted = PersistedRecipe(from: sampleRecipe)
        await repository.add(samplePersisted)
    }

    override func tearDown() async throws {
        await repository.reset()
        repository = nil
        sampleRecipe = nil
        samplePersisted = nil
    }

    // MARK: - RecipeDetailViewModel Tests

    func testDetailViewModel_toggleFavouriteUpdatesState() async {
        let vm = RecipeDetailViewModel(recipe: sampleRecipe, repository: repository)
        await Task.yield()

        XCTAssertFalse(vm.isFavourite, "Initially not favourite")

        await vm.toggleFavourite()

        XCTAssertTrue(vm.isFavourite, "Favourite state should be toggled")
        let favs = await repository.getFavouriteRecipes()
        XCTAssertTrue(favs.contains(where: { $0.id == sampleRecipe.id }))
    }

    // MARK: - RecipesListViewModel Tests

    func testListViewModel_loadsRecipesAndFavourites() async {
        let listVM = RecipesListViewModel(repository: repository)

        // Mark one favourite
        await repository.toggleFavourite(id: sampleRecipe.id)

        await listVM.load()

        XCTAssertEqual(listVM.recipes.count, 1)
        XCTAssertEqual(listVM.favourites.count, 1)
        XCTAssertEqual(listVM.favourites.first?.id, sampleRecipe.id)
    }

    func testListViewModel_toggleFavouriteUpdatesFavourites() async {
        let listVM = RecipesListViewModel(repository: repository)
        await listVM.load()

        XCTAssertTrue(listVM.favourites.isEmpty, "Initially no favourites")

        // Toggle favourite
        await listVM.toggleFavourite(recipe: sampleRecipe)

        XCTAssertEqual(listVM.favourites.count, 1)
        XCTAssertEqual(listVM.favourites.first?.id, sampleRecipe.id)

        // Toggle again
        await listVM.toggleFavourite(recipe: sampleRecipe)
        XCTAssertTrue(listVM.favourites.isEmpty, "Favourite should be removed")
    }
}
