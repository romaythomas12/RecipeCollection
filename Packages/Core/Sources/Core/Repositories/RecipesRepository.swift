//
//  RecipesRepositoryProtocol.swift
//  Core
//
//  Created by Thomas Romay on 09/12/2025.
//

import CoreDB
import Foundation

public actor RecipesRepository: RecipesRepositoryProtocol {
    private let remote: RecipesRemoteServiceProtocol
    private let local: RecipesLocalServiceProtocol

    public init(
        remote: RecipesRemoteServiceProtocol,
        local: RecipesLocalServiceProtocol
    ) {
        self.remote = remote
        self.local = local
    }

    public func fetchRecipes() async throws -> [Recipe] {
        do {
            let remoteRecipes = try await remote.fetchRecipes(from: 0, size: 20, tags: "under_30_minutes")
            await local.save(remoteRecipes.map { PersistedRecipe(from: $0) })
            return remoteRecipes
        } catch {
            let cached = await local.loadAll()
            return cached.map { $0.toDomain() }
        }
    }

    public func getFavouriteRecipes() async -> [Recipe] {
        let favs = await local.loadFavourites()
        return favs.map { $0.toDomain() }
    }

    public func toggleFavourite(id: Int) async {
        await local.toggleFavourite(id: id)
    }
}
