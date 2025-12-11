//
//  RecipeRow.swift
//  RecipesFeature
//
//  Created by Thomas Romay on 11/12/2025.
//

import Core
import CoreUI
import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        GenericListRow(
            thumbnailURL: URL(string: recipe.thumbnailURL),
            thumbnailSize: CGSize(width: 60, height: 60)
        ) {
            Text(recipe.name)
                .font(.body)
                .lineLimit(2)
        }
    }
}
