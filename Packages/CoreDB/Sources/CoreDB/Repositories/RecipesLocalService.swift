//
//  RecipesLocalServiceProtocol.swift
//  CoreDB
//
//  Created by Thomas Romay on 09/12/2025.
//

import Foundation
import RealmSwift

// MARK: - Local Service Protocol

public protocol RecipesLocalServiceProtocol: Sendable {
    func save(_ recipes: [PersistedRecipe]) async
    func loadAll() async -> [PersistedRecipe]
    func loadFavourites() async -> [PersistedRecipe]
    func toggleFavourite(id: Int) async
}

// MARK: - Actor Implementation

public actor RecipesLocalService: RecipesLocalServiceProtocol {
    private let inMemoryIdentifier: String?
    
    public init(inMemoryIdentifier: String? = nil) {
        self.inMemoryIdentifier = inMemoryIdentifier
    }
    
    private func makeRealm() throws -> Realm {
        if let id = inMemoryIdentifier {
            let config = Realm.Configuration(inMemoryIdentifier: id)
            return try Realm(configuration: config)
        } else {
            return try Realm()
        }
    }
    
    public func save(_ recipes: [PersistedRecipe]) async {
        do {
            let realm = try makeRealm()
            try realm.write {
                for persisted in recipes {
                    let existing = realm.object(ofType: RealmRecipe.self, forPrimaryKey: persisted.id)
                    let obj = RealmRecipe(from: persisted)
                    if let existing = existing {
                        obj.isFavourite = existing.isFavourite
                    }
                    realm.add(obj, update: .modified)
                }
            }
        } catch {
            print("Realm save error:", error)
        }
    }
    
    public func loadAll() async -> [PersistedRecipe] {
        do {
            let realm = try makeRealm()
            let objects = Array(realm.objects(RealmRecipe.self))
            return objects.map { $0.toPersisted() }
        } catch {
            print("Realm loadAll error:", error)
            return []
        }
    }
    
    public func loadFavourites() async -> [PersistedRecipe] {
        do {
            let realm = try makeRealm()
            let objects = Array(realm.objects(RealmRecipe.self).filter("isFavourite == true"))
            return objects.map { $0.toPersisted() }
        } catch {
            print("Realm loadFavourites error:", error)
            return []
        }
    }
    
    public func toggleFavourite(id: Int) async {
        do {
            let realm = try makeRealm()
            guard let obj = realm.object(ofType: RealmRecipe.self, forPrimaryKey: id) else { return }
            try realm.write {
                obj.isFavourite.toggle()
            }
        } catch {
            print("Toggle favourite error:", error)
        }
    }
}
