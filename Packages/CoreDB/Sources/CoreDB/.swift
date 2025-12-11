//
//  RealmRecipe.swift
//  CoreDB
//
//  Created by Thomas Romay on 05/12/2025.
//


//import RealmSwift
//
//class RealmRecipe: Object {
//    @Persisted var id: Int
//    @Persisted var name: String
//    @Persisted var descriptionText: String?
//    @Persisted var thumbnailURL: String?
//    
//    convenience init(from recipe: Recipe) {
//        self.init()
//        self.id = recipe.id
//        self.name = recipe.name
//        self.descriptionText = recipe.description
//        self.thumbnailURL = recipe.thumbnailURL
//    }
//    
//    func toDomain() -> Recipe {
//        Recipe(id: id, name: name, description: descriptionText, thumbnailURL: thumbnailURL)
//    }
//}
