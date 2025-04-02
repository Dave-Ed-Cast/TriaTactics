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
    @EnvironmentObject var view: Navigation

    @Environment(\.device) private var device

    @State private var showAlert = false
    @State private var showWinnerOverlay = false

    let xSize: CGFloat = UIScreen.main.bounds.width

    var body: some View {

        VStack {

            ZStack(alignment: device == .pad ? .top : .bottom) {
                Rectangle()
                    .foregroundStyle(.backgroundTheme.opacity(0.6))
                    .if(device == .pad) { rectangle in
                        rectangle
                            .padding(.bottom, 130)
                    }

                HStack(alignment: .center) {
                    Group {
                        if view.value == .online {
                            playerImageView()
                                .frame(width: xSize * 0.17, height: xSize * 0.17)

                            playerTurnText()
                                .frame(width: xSize * 0.5, height: xSize * 0.2)
                        } else {
                            offlineImageView()
                                .frame(width: xSize * 0.17, height: xSize * 0.17)

                            offlineText()
                                .frame(width: xSize * 0.5, height: xSize * 0.2)
                        }
                    }
                    .padding(.bottom, 15)
                } // end of HStack
                .padding(.top, 25)
                .foregroundStyle(.textTheme)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            }
            .frame(width: xSize, height: xSize * 0.38)
        }
        .ignoresSafeArea(.all)
    }

    func playerImageView() -> some View {

        if let localPlayerImage = matchManager.localPlayerImage,
           let uiImage = UIImage(data: localPlayerImage) {
            return Image(uiImage: uiImage)
                .resizable()
        } else {
            let systemImageName = matchManager.currentlyPlaying ? "person.circle" : "person.circle.fill"
            return Image(systemName: systemImageName)
                .resizable()
        }
    }

    func playerTurnText() -> some View {
        let displayName = matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : (matchManager.otherPlayer?.displayName ?? "Unknown")
        return Text("\(displayName)'s turn")
            .fontWeight(.semibold)
            .font(device == .pad ? .largeTitle : .title)

    }

    func offlineImageView() -> some View {
        let symbolImage = gameLogic.activePlayer == .X ? "X" : "O"
        return Image(symbolImage)
            .resizable()
    }

    func offlineText() -> some View {
        let turnText: String
        if view.value == .bot {
            turnText = gameLogic.activePlayer == .X ? "It's your turn" : "AI's turn"
        } else {
            turnText = "It's your turn"
        }
        return Text(turnText)
            .fontWeight(.semibold)
            .font(device == .pad ? .largeTitle : .title)
            .frame(width: xSize * 0.5, height: xSize * 0.2)
    }
}

#Preview("Offline") {
    TopHUD()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    TopHUD()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("AI") {
    TopHUD()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}

#Preview("game") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
