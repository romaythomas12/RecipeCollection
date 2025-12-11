//
//  Recipe.swift
//  Core
//
//  Created by Thomas Romay on 01/12/2025.
//

import CoreDB
import Foundation

// MARK: - Domain Models

public struct Recipe: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnailURL: String
    public let videoURL: String?
    public let servings: Int
    public let totalTimeMinutes: Int?
    public let ratingScore: Double
    public let ingredients: [IngredientItem]
    public let instructions: [InstructionItem]

    public init(id: Int, name: String, description: String, thumbnailURL: String, videoURL: String?, servings: Int, totalTimeMinutes: Int?, ratingScore: Double, ingredients: [IngredientItem], instructions: [InstructionItem]) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.servings = servings
        self.totalTimeMinutes = totalTimeMinutes
        self.ratingScore = ratingScore
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

public struct IngredientItem: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let rawText: String

    public init(id: Int, name: String, rawText: String) {
        self.id = id
        self.name = name
        self.rawText = rawText
    }
}

public struct InstructionItem: Identifiable, Equatable, Sendable, Hashable {
    public let id: Int
    public let text: String
    public let position: Int

    public init(id: Int, text: String, position: Int) {
        self.id = id
        self.text = text
        self.position = position
    }
}

// MARK: - Mapping between PersistedRecipe <-> Recipe

// MARK: - PersistedRecipe <-> Recipe Mapping

public extension PersistedRecipe {
    /// Convert persisted model to domain model
    func toDomain() -> Recipe {
        Recipe(
            id: id,
            name: name,
            description: description,
            thumbnailURL: thumbnailURL,
            videoURL: videoURL,
            servings: servings,
            totalTimeMinutes: totalTimeMinutes,
            ratingScore: ratingScore,
            ingredients: ingredients.map { $0.toDomain() },
            instructions: instructions.map { $0.toDomain() }
        )
    }

    /// Initialize PersistedRecipe from domain model
    init(from domain: Recipe) {
        self.init(
            id: domain.id,
            name: domain.name,
            description: domain.description,
            thumbnailURL: domain.thumbnailURL,
            videoURL: domain.videoURL,
            servings: domain.servings,
            totalTimeMinutes: domain.totalTimeMinutes,
            ratingScore: domain.ratingScore,
            isFavourite: false,
            ingredients: domain.ingredients.map { PersistedIngredientItem(from: $0) },
            instructions: domain.instructions.map { PersistedInstructionItem(from: $0) }
        )
    }
}

// MARK: - Ingredient Mapping

public extension PersistedIngredientItem {
    func toDomain() -> IngredientItem {
        IngredientItem(id: id, name: name, rawText: rawText)
    }

    init(from domain: IngredientItem) {
        self.init(
            id: domain.id,
            name: domain.name,
            rawText: domain.rawText
        )
    }
}

// MARK: - Instruction Mapping

public extension PersistedInstructionItem {
    func toDomain() -> InstructionItem {
        InstructionItem(id: id, text: text, position: position)
    }

    init(from domain: InstructionItem) {
        self.init(
            id: domain.id,
            text: domain.text,
            position: domain.position
        )
    }
}
