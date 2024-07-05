//
//  TopHUD.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 05/07/24.
//
//

import SwiftUI

struct TopHUD: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var changeViewTo: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false

    let xSize: CGFloat = UIScreen.main.bounds.width

    var body: some View {

        VStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(.backgroundTheme.opacity(0.6))

                HStack(alignment: .center) {

                    if changeViewTo.value == .online {
                        if let imageData = matchManager.localPlayerImage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: xSize * 0.1, height: xSize * 0.1)
                                .padding(.vertical, 20)
                        }
                        Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")'s turn")

                            .frame(width: xSize * 0.4, height: 0)
                    } else {
                        Image("\(gameLogic.activePlayer == .X ? "X" : "O")")
                            .resizable()
                            .frame(width: xSize * 0.1, height: xSize * 0.1)

                        Text(changeViewTo.value == .bot ? (gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn") : "It's your turn")
                            .frame(width: xSize * 0.4, height: 0)
                    }
                } // end of HStack
                .foregroundStyle(.textTheme)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            }
            .frame(height: xSize * 0.3)

        }
        .ignoresSafeArea()

    }
}

#Preview("Offline") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("AI") {
    TopHUD()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
