//
//  RealmIngredient.swift
//  CoreDB
//
//  Created by Thomas Romay on 09/12/2025.
//

import Foundation
import RealmSwift

public class RealmRecipe: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var name: String = ""
    @objc public dynamic var desc: String = ""
    @objc public dynamic var thumbnailURL: String = ""
    @objc public dynamic var videoURL: String?
    @objc public dynamic var servings: Int = 0
    @objc public dynamic var totalTimeMinutes: Int = 0
    @objc public dynamic var ratingScore: Double = 0.0
    @objc public dynamic var isFavourite: Bool = false

    public let ingredients = List<RealmIngredient>()
    public let instructions = List<RealmInstruction>()

    override public static func primaryKey() -> String? { "id" }
}

public class RealmIngredient: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var name: String = ""
    @objc public dynamic var rawText: String = ""
}

public class RealmInstruction: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var text: String = ""
    @objc public dynamic var position: Int = 0
}

public extension RealmRecipe {
    /// Initialize RealmRecipe from PersistedRecipe
    convenience init(from persisted: PersistedRecipe) {
        self.init()
        self.id = persisted.id
        self.name = persisted.name
        self.desc = persisted.description
        self.thumbnailURL = persisted.thumbnailURL
        self.videoURL = persisted.videoURL
        self.servings = persisted.servings
        self.totalTimeMinutes = persisted.totalTimeMinutes ?? 0
        self.ratingScore = persisted.ratingScore
        self.isFavourite = persisted.isFavourite ?? false
        // Map ingredients
        let ingrObjects = persisted.ingredients.map { RealmIngredient(from: $0) }
        self.ingredients.append(objectsIn: ingrObjects)

        // Map instructions
        let instrObjects = persisted.instructions.map { RealmInstruction(from: $0) }
        self.instructions.append(objectsIn: instrObjects)
    }

    func toPersisted() -> PersistedRecipe {
        PersistedRecipe(
            id: id,
            name: name,
            description: desc,
            thumbnailURL: thumbnailURL,
            videoURL: videoURL,
            servings: servings,
            totalTimeMinutes: totalTimeMinutes == 0 ? nil : totalTimeMinutes,
            ratingScore: ratingScore,
            isFavourite: isFavourite,
            ingredients: ingredients.map { $0.toDomain() },
            instructions: instructions.map { $0.toDomain() }
        )
    }
}

extension RealmIngredient {
    convenience init(from item: PersistedIngredientItem) {
        self.init()
        self.id = item.id
        self.name = item.name
        self.rawText = item.rawText
    }

    func toDomain() -> PersistedIngredientItem {
        PersistedIngredientItem(id: id, name: name, rawText: rawText)
    }
}

// MARK: - RealmInstruction <-> Persisted DTO

extension RealmInstruction {
    convenience init(from item: PersistedInstructionItem) {
        self.init()
        self.id = item.id
        self.text = item.text
        self.position = item.position
    }

    func toDomain() -> PersistedInstructionItem {
        PersistedInstructionItem(id: id, text: text, position: position)
    }
}
