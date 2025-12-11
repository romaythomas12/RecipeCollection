//
//  RecipesLocalServiceTests.swift
//  CoreDB
//
//  Created by Thomas Romay on 11/12/2025.
//

@testable import CoreDB
import RealmSwift
import XCTest

final class RecipesLocalServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
    }
    
    // MARK: - Helpers
    
    private func makeService() -> RecipesLocalService {
        RecipesLocalService(inMemoryIdentifier: UUID().uuidString)
    }
    
    private func sampleRecipe(id: Int = 1, fav: Bool = false) -> PersistedRecipe {
        PersistedRecipe(
            id: id,
            name: "Test Recipe",
            description: "Sample",
            thumbnailURL: "url",
            videoURL: nil,
            servings: 2,
            totalTimeMinutes: 10,
            ratingScore: 4.5,
            isFavourite: fav,
            ingredients: [
                PersistedIngredientItem(id: 1, name: "Salt", rawText: "1 tsp salt")
            ],
            instructions: [
                PersistedInstructionItem(id: 1, text: "Mix", position: 1)
            ]
        )
    }
    
    // MARK: - TEST: Save and Load
    
    func test_save_and_load_recipes() async throws {
        let service = makeService()
        let recipe = sampleRecipe()
        
        await service.save([recipe])
        let loaded = await service.loadAll()
        
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, recipe.id)
        XCTAssertEqual(loaded.first?.name, "Test Recipe")
    }
    
    // MARK: - TEST: Toggle Favourite
    
    func test_toggle_favourite_updates_isFavourite() async {
        let service = makeService()
        let recipe = sampleRecipe(id: 10, fav: false)
        
        await service.save([recipe])
        
        await service.toggleFavourite(id: 10)
        var loaded = await service.loadAll()
        
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.isFavourite, true)
        
        await service.toggleFavourite(id: 10)
        loaded = await service.loadAll()
        
        XCTAssertEqual(loaded.first?.isFavourite, false)
    }
    
    // MARK: - TEST: Load Favourites
    
    func test_load_favourites_returns_only_favourited_items() async {
        let service = makeService()
        
        await service.save([
            sampleRecipe(id: 1, fav: false),
            sampleRecipe(id: 2, fav: true),
            sampleRecipe(id: 3, fav: true)
        ])
        
        let favs = await service.loadFavourites()
        
        XCTAssertEqual(favs.map { $0.id }.sorted(), [2, 3])
    }
    
    // MARK: - TEST: Save Preserves Existing Favourite
    
    func test_save_preserves_existing_favourite_flag() async {
        let service = makeService()
        
        await service.save([sampleRecipe(id: 42, fav: false)])
        
        await service.toggleFavourite(id: 42)
        
        let afterToggle = await service.loadAll()
        XCTAssertTrue(afterToggle.first?.isFavourite == true)
        
        let incoming = sampleRecipe(id: 42, fav: false)
        await service.save([incoming])
        
        let finalState = await service.loadAll()
        XCTAssertTrue(finalState.first?.isFavourite == true, "Save should preserve favourite state")
    }
    
    // MARK: - TEST: Empty Loads
    
    func test_loadAll_returns_empty_when_no_data() async {
        let service = makeService()
        let result = await service.loadAll()
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_loadFavourites_returns_empty_when_no_favourites() async {
        let service = makeService()
        let result = await service.loadFavourites()
        XCTAssertTrue(result.isEmpty)
    }
}
