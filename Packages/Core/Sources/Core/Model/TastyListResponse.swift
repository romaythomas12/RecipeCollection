//
//  TastyListResponse.swift
//  Core
//
//  Created by Thomas Romay on 09/12/2025.
//

public struct TastyListResponse: Codable {
    public let count: Int
    public let results: [TastyRecipe]
}

public struct TastyRecipe: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let thumbnailUrl: String?
    public let videoUrl: String?
    public let numServings: Int?
    public let totalTimeMinutes: Int?
    public let userRatings: TastyUserRatings?
    public let sections: [TastySection]?
    public let instructions: [TastyInstruction]?
}

public struct TastyUserRatings: Codable {
    public let score: Double?
}

public struct TastySection: Codable {
    public let components: [TastyComponent]?
}

public struct TastyComponent: Codable {
    public let id: Int
    public let rawText: String
    public let ingredient: TastyIngredient?
}

public struct TastyIngredient: Codable {
    public let id: Int?
    public let name: String?
}

public struct TastyInstruction: Codable {
    public let id: Int
    public let displayText: String
    public let position: Int
}

extension TastyRecipe {
    func toDomain() -> Recipe {
        Recipe(
            id: id,
            name: name,
            description: description ?? "",
            thumbnailURL: thumbnailUrl ?? "",
            videoURL: videoUrl,
            servings: numServings ?? 0,
            totalTimeMinutes: totalTimeMinutes,
            ratingScore: userRatings?.score ?? 0,
            ingredients: sections?.flatMap { $0.toDomainIngredients() } ?? [],
            instructions: instructions?.map { $0.toDomain() } ?? []
        )
    }
}

extension TastySection {
    func toDomainIngredients() -> [IngredientItem] {
        (components ?? []).map { component in
            IngredientItem(
                id: component.id,
                name: component.ingredient?.name ?? "",
                rawText: component.rawText
            )
        }
    }
}

extension TastyInstruction {
    func toDomain() -> InstructionItem {
        InstructionItem(
            id: id,
            text: displayText,
            position: position
        )
    }
}
