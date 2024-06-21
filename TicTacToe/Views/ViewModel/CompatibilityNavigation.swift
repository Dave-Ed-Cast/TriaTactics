//
//  CompatibilityNavigation.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 20/06/24.
//

import SwiftUI
// view che passa a navigationstack se possibile, altrimenti navigationview
struct CompatibilityNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}
