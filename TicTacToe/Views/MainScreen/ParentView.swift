//
//  ParentView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct ParentView: View {
    @EnvironmentObject var navigation: Navigation
    var body: some View {
        switch navigation.value {
            case .main: MainView()
            case .play: PlayView()
            case .online: GameView(isOffline: .constant(false))
            case .offline: GameView(isOffline: .constant(true))
            case .bot: GameView(isOffline: .constant(false))
            case .tutorial: TutorialView()
        }
    }
}

#Preview {
    ParentView()
}
