//
//  GenericListRow.swift
//  CoreUI
//
//  Created by Thomas Romay on 11/12/2025.
//

import SwiftUI
public struct GenericListRow<Content: View>: View {
    let thumbnailURL: URL?
    let thumbnailSize: CGSize
    let content: () -> Content
    
    public init(
        thumbnailURL: URL? = nil,
        thumbnailSize: CGSize = .init(width: 60, height: 60),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.thumbnailURL = thumbnailURL
        self.thumbnailSize = thumbnailSize
        self.content = content
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            AsyncThumbnail(
                url: thumbnailURL,
                cornerRadius: 8,
                contentMode: .fill
            )
            .frame(width: thumbnailSize.width, height: thumbnailSize.height) // fixed here
            .clipped() // ensure content does not overflow
            
            content()
        }
        .padding(.vertical, 4)
    }
}
