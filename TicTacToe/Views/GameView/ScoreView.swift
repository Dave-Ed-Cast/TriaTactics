//
//  ScoreView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 03/07/24.
//

import SwiftUI

struct ScoreView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

    let xSize = UIScreen.main.bounds.width

    var body: some View {
        VStack(spacing: 20) {
            Text("Score")
                .fontWeight(.semibold)
                .font(.title3)
                .foregroundStyle(.textTheme)

            HStack {
                ResponsiveScore(player: "left", invert: false)
                ResponsiveScore(player: "right", invert: true)
            }
            .frame(width: xSize)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview("Offline") {
    ScoreView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())

}
#Preview("Online") {
    ScoreView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("Game") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
