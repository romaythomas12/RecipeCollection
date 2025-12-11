//
//  GenericAsyncThumbnail.swift
//  CoreUI
//
//  Created by Thomas Romay on 11/12/2025.
//
import SwiftUI

public struct AsyncThumbnail: View {
    let url: URL?
    let cornerRadius: CGFloat
    let contentMode: ContentMode
    let placeholder: AnyView
    let failureView: AnyView

    public init(
        url: URL?,
        cornerRadius: CGFloat = 12,
        contentMode: ContentMode = .fill,
        placeholder: AnyView = AnyView(ProgressView()),
        failureView: AnyView = AnyView(Color.gray.opacity(0.3))
    ) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.placeholder = placeholder
        self.failureView = failureView
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)

            case .empty:
                placeholder

            case .failure:
                failureView

            @unknown default:
                failureView
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
