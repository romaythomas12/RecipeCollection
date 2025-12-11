import CoreUI
import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncThumbnail(
                    url: URL(string: viewModel.recipe.thumbnailURL),
                    cornerRadius: 12,
                    contentMode: .fit
                )
                .frame(maxWidth: 420)
                .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.recipe.name)
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)

                    Text(viewModel.recipe.description)
                        .font(.body)
                        .accessibilityLabel("Description: \(viewModel.recipe.description)")
                }

                ActionButton(
                    title: viewModel.isFavourite ? "Remove from favourites" : "Add to favourites",
                    systemImage: viewModel.isFavourite ? "heart.fill" : "heart",
                    backgroundColor: viewModel.isFavourite ? Color.red.opacity(0.8) : Color.blue.opacity(0.8),
                    foregroundColor: .white,
                    accessibilityLabel: viewModel.isFavourite ? "Remove from favourites" : "Add to favourites",
                    accessibilityHint: "Marks or unmarks the recipe as favourite",
                    action: { await viewModel.toggleFavourite() }
                )
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.initialize()
        }
    }
}
