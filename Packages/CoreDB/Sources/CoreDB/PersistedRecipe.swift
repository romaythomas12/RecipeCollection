//
//  PersistedRecipe.swift
//  CoreDB
//
//  Created by Thomas Romay on 11/12/2025.
//

import Foundation
import RealmSwift

public struct PersistedRecipe: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnailURL: String
    public let videoURL: String?
    public let servings: Int
    public let totalTimeMinutes: Int?
    public let ratingScore: Double
    public var isFavourite: Bool?
    public let ingredients: [PersistedIngredientItem]
    public let instructions: [PersistedInstructionItem]

    public init(id: Int, name: String, description: String, thumbnailURL: String, videoURL: String?, servings: Int, totalTimeMinutes: Int?, ratingScore: Double, isFavourite: Bool?, ingredients: [PersistedIngredientItem], instructions: [PersistedInstructionItem]) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.servings = servings
        self.totalTimeMinutes = totalTimeMinutes
        self.ratingScore = ratingScore
        self.isFavourite = isFavourite
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

public struct PersistedIngredientItem: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let rawText: String

    public init(id: Int, name: String, rawText: String) {
        self.id = id
        self.name = name
        self.rawText = rawText
    }
}

public struct PersistedInstructionItem: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let text: String
    public let position: Int
    public init(id: Int, text: String, position: Int) {
        self.id = id
        self.text = text
        self.position = position
    }
}
