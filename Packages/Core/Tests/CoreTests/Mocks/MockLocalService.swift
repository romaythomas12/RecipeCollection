//
//  MockLocalService.swift
//  CoreDB
//
//  Created by Thomas Romay on 11/12/2025.
//

@testable import CoreDB
import Foundation

public actor MockLocalService: RecipesLocalServiceProtocol {
    var stored: [PersistedRecipe] = []
    var saved: [PersistedRecipe] = []
    var favourites: [PersistedRecipe] = []

    init(stored: [PersistedRecipe], saved: [PersistedRecipe], favourites: [PersistedRecipe]) {
        self.stored = stored
        self.saved = saved
        self.favourites = favourites
    }

    public func save(_ recipes: [PersistedRecipe]) async {
        saved = recipes
        stored = recipes
    }

    public func loadAll() async -> [PersistedRecipe] {
        stored
    }

    public func loadFavourites() async -> [PersistedRecipe] {
        favourites
    }

    public func toggleFavourite(id: Int) async {
        if let index = stored.firstIndex(where: { $0.id == id }) {
            stored[index].isFavourite?.toggle()
        }
    }
}
