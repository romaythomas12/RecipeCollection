//
//  GenericActionButton.swift
//  CoreUI
//
//  Created by Thomas Romay on 11/12/2025.
//
import SwiftUI

public struct ActionButton: View {
    let title: String
    let systemImage: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let accessibilityLabel: String
    let accessibilityHint: String
    let action: () async -> Void

    public init(title: String, systemImage: String?, backgroundColor: Color, foregroundColor: Color, accessibilityLabel: String, accessibilityHint: String, action: @escaping () async -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        Button {
            Task { await action() }
        } label: {
            HStack {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .contentTransition(.opacity)
    }
}
