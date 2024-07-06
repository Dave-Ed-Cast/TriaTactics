//
//  AnimationSettings.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

class AnimationSettings: ObservableObject {
    @Published var isAnimationEnabled: Bool

    init(isAnimationEnabled: Binding<Bool>) {
        self._isAnimationEnabled = Published(initialValue: isAnimationEnabled.wrappedValue)
    }
}
