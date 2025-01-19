//
//  CustomPushTransitionModifier.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

struct PushTransition: ViewModifier {
    let isActive: Bool
    let direction: Edge
    let width = UIScreen.main.bounds.width

    func body(content: Content) -> some View {
        content
            .offset(x: isActive ? 0 : direction == .leading ? -width : width, y: 0)
            .opacity(isActive ? 1 : 0)
            .animation(.easeInOut, value: isActive)
    }
}
