//
//  RecipesFactoryTests.swift
//  RecipesFeature
//
//  Created by Thomas Romay on 11/12/2025.
//

@testable import Core
@testable import RecipesFeature
import SwiftUI
import XCTest

@MainActor
final class RecipesFactoryTests: XCTestCase {
    func test_factory_builds_list_view() {
        let repo = MockRecipesRepository()
        let factory = RecipesFactory(repository: repo)
        
        let view = factory.makeRecipesListView()
        
        XCTAssertNotNil(view)
    }
    
    func test_factory_builds_detail_view() {
        let repo = MockRecipesRepository()
        let factory = RecipesFactory(repository: repo)
        
        let view = factory.makeRecipeDetailView(makeRecipe(id: 1))
        
        XCTAssertNotNil(view)
    }
}

private extension RecipesFactoryTests {
    func makeRecipe(id: Int = 1) -> Recipe {
        Recipe(id: id,
               name: "Recipe \(id)",
               description: "Description \(id)",
               thumbnailURL: "http://image.com/\(id)",
               videoURL: nil,
               servings: 2,
               totalTimeMinutes: 20,
               ratingScore: 4.5,
               ingredients: [],
               instructions: [])
    }
}
