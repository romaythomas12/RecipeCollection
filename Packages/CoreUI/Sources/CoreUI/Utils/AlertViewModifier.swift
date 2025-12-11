//
//  AlertViewModifier.swift
//  CoreUI
//
//  Created by Thomas Romay on 05/12/2025.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(message)
            }
    }
}
