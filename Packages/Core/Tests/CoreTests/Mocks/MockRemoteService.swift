//
//  MockRemoteService.swift
//  Core
//
//  Created by Thomas Romay on 11/12/2025.
//

@testable import Core

actor MockRemoteService: RecipesRemoteServiceProtocol {
    var result: Result<[Recipe], Error> = .success([])

    init(result: Result<[Recipe], Error>) {
        self.result = result
    }

    func fetchRecipes(from: Int, size: Int, tags: String) async throws -> [Recipe] {
        switch result {
            case .success(let r): return r
            case .failure(let e): throw e
        }
    }
}
