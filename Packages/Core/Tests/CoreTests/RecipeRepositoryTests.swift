//
//  RecipeRepositoryTests.swift
//  Core
//
//  Created by Thomas Romay on 05/12/2025.
//

@testable import Core
@testable import CoreDB
import Foundation
import Testing

struct RecipeRepositoryTests {
    @Test
    func test_fetchRecipes_invalidStatusCode() async {
        let response = HTTPURLResponse(
            url: URL(string: "https://mock")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let session = MockNetworkSession(
            dataResult: .success((Data(), response))
        )
        
        let service = RecipesRemoteService(session: session)
        
        do {
            _ = try await service.fetchRecipes()
            Issue.record("Expected failure but succeeded")
        } catch let NetworkError.statusCode(code) {
            #expect(code == 500)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test
    func test_fetchRecipes_remoteSuccess_savesToLocal() async throws {
        // Arrange
        let sample = Recipe(
            id: 1, name: "Pizza",
            description: "Good",
            thumbnailURL: "t",
            videoURL: nil,
            servings: 1,
            totalTimeMinutes: 5,
            ratingScore: 4.0,
            ingredients: [],
            instructions: []
        )
        
        let remote = MockRemoteService(result: .success([sample]))
        
        let local = MockLocalService(stored: [], saved: [], favourites: [])
        let repo = RecipesRepository(remote: remote, local: local)
        
        // Act
        let output = try await repo.fetchRecipes()
        
        // Assert
        #expect(output.count == 1)
        
        let saved = await local.saved
        #expect(saved.count == 1)
        #expect(saved.first?.id == 1)
    }
    
    @Test
    func test_fetchRecipes_remoteFails_returnsCached() async throws {
        let remote = MockRemoteService(result: .failure(NetworkError.requestFailed(NSError())))
        
        let cached = PersistedRecipe(
            id: 5,
            name: "Cached",
            description: "Desc",
            thumbnailURL: "",
            videoURL: nil,
            servings: 1,
            totalTimeMinutes: nil,
            ratingScore: 3.0,
            isFavourite: false,
            ingredients: [],
            instructions: []
        )
        
        let local = MockLocalService(stored: [cached], saved: [], favourites: [])
        
        let repo = RecipesRepository(remote: remote, local: local)
        
        let result = try await repo.fetchRecipes()
        
        #expect(result.first?.id == 5)
        #expect(result.first?.name == "Cached")
    }
    
    @Test
    func test_toggleFavourite() async {
        let recipe = PersistedRecipe(
            id: 10,
            name: "Test",
            description: "",
            thumbnailURL: "",
            videoURL: nil,
            servings: 1,
            totalTimeMinutes: nil,
            ratingScore: 4.0,
            isFavourite: false,
            ingredients: [],
            instructions: []
        )
        
        let remote = MockRemoteService(result: .success([]))
        
        let local = MockLocalService(stored: [recipe], saved: [], favourites: [])
        
        let repo = RecipesRepository(remote: remote, local: local)
        
        // Act
        await repo.toggleFavourite(id: 10)
        
        // Assert
        let updated = await local.stored.first
        #expect(updated?.isFavourite == true)
    }
}
