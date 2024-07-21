//
//  ResponsiveScore.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 05/07/24.
//

import SwiftUI

struct ResponsiveScore: View {

    @EnvironmentObject var view: Navigation
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic

    @State private var gameTurns = 0

    let xSize = UIScreen.main.bounds.width
    let ySize = UIScreen.main.bounds.height

    let player: String
    let invert: Bool

    private var animationTriggerValue: Int {
        let trigger = gameLogic.xScore + gameLogic.oScore + matchManager.localPlayerScore + matchManager.otherPlayerScore
        return trigger <= 100 ? trigger : 0
    }

    var body: some View {
        Group {
            ZStack {
                CustomRectangle(invert: invert)
                .offset(x: moveWinner(for: xSize))
                .animation(.snappy(duration: 1), value: animationTriggerValue)
                .overlay {
                    Group {
                        let absDifference = Double(abs(gameLogic.xScore - gameLogic.oScore))
                        let scaleFactor = (absDifference < 3 ? absDifference : 3) * 0.33
                        let yOffset = ySize * -0.003 * (absDifference < 3 ? absDifference : 3)

                        if  absDifference >= 1.0 {
                            withAnimation {
                                LottieAnimation(
                                    name: "Fire",
                                    contentMode: .scaleAspectFit,
                                    playbackMode: (.playing(.fromFrame(1, toFrame: 25, loopMode: .loop))),
                                    scaleFactor: CGFloat(min(scaleFactor, 0.99))
                                )
                                .offset(x: (gameLogic.xScore > gameLogic.oScore ? xSize : -xSize) * 0.25 + moveWinner(for: xSize), y: yOffset)
                                .animation(.snappy(duration: 1), value: absDifference)
                            }
                        }
                    }
                }

                HStack(spacing: 5) {
                    if !invert {
                        if view.value == .offline || view.value == .bot {
                            Image(player == "left" ? "X" : "O")
                                .resizable()
                                .frame(width: xSize * 0.13, height: xSize * 0.13)
                        } else {

                            let localPlayer = matchManager.localPlayerImage
                            let otherPlayer = matchManager.otherPlayerImage

                            let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)

                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: xSize * 0.13, height: xSize * 0.13)
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

                        if view.value == .offline || view.value == .bot {
                            Image(player == "left" ? "X" : "O")
                                .resizable()
                                .frame(width: xSize * 0.13, height: xSize * 0.13)
                        } else {

                            let localPlayer = matchManager.localPlayerImage
                            let otherPlayer = matchManager.otherPlayerImage

                            let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)

                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: xSize * 0.13, height: xSize * 0.13)
                        }

                    }
                }
                .foregroundStyle(.textTheme)
                .font(.title)
            }
            .foregroundStyle(.backgroundTheme)
            // change width to adjust symbol and text
            .frame(width: xSize / 1.42, height: ySize * 0.08)
        }
        .ignoresSafeArea(.all)
    }

    func moveWinner(for value: CGFloat) -> CGFloat {
        let multiplyingFactor = 0.042
        let difference = abs(gameLogic.xScore - gameLogic.oScore)
        if difference >= 0 && difference <= 5 {
            return CGFloat(gameLogic.xScore - gameLogic.oScore) * value * multiplyingFactor
        } else {
            return CGFloat(gameLogic.xScore > gameLogic.oScore ? 5 : -5) * value * multiplyingFactor
        }
    }

    func systemImageData(systemName: String) -> Data? {
        let image = UIImage(systemName: systemName)
        return image?.pngData()
    }

    func playerScore() -> Int {

        if view.value == .online {
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
    .environmentObject(MatchManager.shared)
    .environmentObject(GameLogic.shared)
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
    .environmentObject(MatchManager.shared)
    .environmentObject(GameLogic.shared)
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
    .environmentObject(MatchManager.shared)
    .environmentObject(GameLogic.shared)
    .environmentObject({
        let navigation = Navigation.shared
        navigation.value = .bot
        return navigation
    }())
}
