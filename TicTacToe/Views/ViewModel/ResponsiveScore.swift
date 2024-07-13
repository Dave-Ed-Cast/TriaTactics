//
//  ResponsiveScore.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 05/07/24.
//

import SwiftUI

struct ResponsiveScore: View {

    @EnvironmentObject var changeViewTo: Navigation
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

    let xSize = UIScreen.main.bounds.width
    let ySize = UIScreen.main.bounds.height

    let player: String
    let invert: Bool

    @State private var gameTurns = 0

    private var animationTriggerValue: Int {
        let trigger = gameLogic.xScore + gameLogic.oScore + matchManager.localPlayerScore + matchManager.otherPlayerScore
        return trigger <= 20 ? trigger : 0
    }

    var body: some View {
        Group {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .offset(x: moveWinner(for: xSize))
                    .animation(.snappy(duration: 1), value: animationTriggerValue)
                    .overlay {
                        Group {
                            if gameLogic.xScore - gameLogic.oScore >= 3 {
                                withAnimation {
                                    LottieAnimation(name: "Fire", contentMode: .scaleAspectFit, playbackMode: (.playing(.fromFrame(1, toFrame: 25, loopMode: .loop))), width: xSize / 3.6, scaleFactor: 1, degrees: -90)
                                        .scaledToFill()
                                        .offset(x: xSize / 4.9 + moveWinner(for: xSize))
                                }
                            }
                        }
                    }

                HStack(spacing: 5) {
                    if !invert {
                        if changeViewTo.value == .offline || changeViewTo.value == .bot {
                            Image(player == "left" ? "X" : "O")
                                .resizable()
                                .frame(width: xSize * 0.1, height: xSize * 0.1)
                        } else {

                            let localPlayer = matchManager.localPlayerImage
                            let otherPlayer = matchManager.otherPlayerImage

                            let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)

                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: xSize * 0.1, height: xSize * 0.1)
                        }
                        Text("\(playerScore())")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.trailing)
                            .frame(width: xSize * 0.1)

                    } else {
                        Text("\(playerScore())")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.trailing)
                            .frame(width: xSize * 0.1)

                        if changeViewTo.value == .offline || changeViewTo.value == .bot {
                            Image(player == "left" ? "X" : "O")
                                .resizable()
                                .frame(width: xSize * 0.1, height: xSize * 0.1)
                        } else {

                            let localPlayer = matchManager.localPlayerImage
                            let otherPlayer = matchManager.otherPlayerImage

                            let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)

                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: xSize * 0.1, height: xSize * 0.1)
                        }

                    }
                }
                .foregroundStyle(.textTheme)
                .font(.title)

            }
            .foregroundStyle(.backgroundTheme)
            .frame(width: xSize / 1.35, height: ySize * 0.09)
        }
        .ignoresSafeArea(.all)
    }

    func moveWinner(for value: CGFloat) -> CGFloat {
        let multiplyingFactor = 0.0468
        let difference = abs(gameLogic.xScore - gameLogic.oScore)
        if difference >= 0 && difference <= 5 {
            return CGFloat(gameLogic.xScore - gameLogic.oScore) * value * multiplyingFactor
        } else {
            return CGFloat(5) * value * multiplyingFactor
        }
    }

    func systemImageData(systemName: String) -> Data? {
        let image = UIImage(systemName: systemName)
        return image?.pngData()
    }

    func playerScore() -> Int {

        if changeViewTo.value == .online {
            return player == "left" ? matchManager.localPlayerScore : matchManager.otherPlayerScore
        } else {
            return player == "left" ? gameLogic.xScore : gameLogic.oScore
        }
    }
}

#Preview("Offline") {
    HStack {
        ResponsiveScore(player: "left", invert: false)
        ResponsiveScore(player: "right", invert: true)
    }
    .environmentObject(MatchManager())
    .environmentObject(GameLogic())
    .environmentObject({
        let navigation = Navigation.shared
        navigation.value = .offline
        return navigation
    }())
}
#Preview("Online") {
    HStack {
        ResponsiveScore(player: "left", invert: false)
        ResponsiveScore(player: "right", invert: true)
    }
    .environmentObject(MatchManager())
    .environmentObject(GameLogic())
    .environmentObject({
        let navigation = Navigation.shared
        navigation.value = .online
        return navigation
    }())
}

#Preview("AI") {
    HStack {
        ResponsiveScore(player: "left", invert: false)
        ResponsiveScore(player: "right", invert: true)
    }
    .environmentObject(MatchManager())
    .environmentObject(GameLogic())
    .environmentObject({
        let navigation = Navigation.shared
        navigation.value = .bot
        return navigation
    }())
}
