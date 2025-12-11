//
//  RecipeCollectionApp.swift
//  RecipeCollection
//
//  Created by Thomas Romay on 11/12/2025.
//

import Core
import CoreDB
import RecipesFeature
import SwiftUI

@main
struct RecipeCollectionApp: App {
    private let factory: RecipesFactoryProtocol
    static let key: String = ""
    init() {
        guard !Self.key.isEmpty else {
            fatalError("API key must be set before running the app")
        }

        let remoteService = RecipesRemoteService(apiKey: Self.key)
        let localService = RecipesLocalService()
        let repository = RecipesRepository(remote: remoteService, local: localService)
        self.factory = RecipesFactory(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            factory.makeRecipesListView()
        }
    }
}
