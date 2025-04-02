//
//  ResponsiveScore.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 05/07/24.
//

import SwiftUI

struct ResponsiveScore: View {

    @EnvironmentObject private var view: Navigation
    @EnvironmentObject private var matchManager: MatchManager
    @EnvironmentObject private var gameLogic: GameLogic

    @Environment(\.device) private var device

    @State private var gameTurns = 0

    let xSize = UIScreen.main.bounds.width
    let ySize = UIScreen.main.bounds.height

    let player: String
    let invert: Bool

    private var animationTriggerValue: Int {
        let trigger = xScore + oScore + localPlayerScore + otherPlayerScore
        return Int(trigger <= 100 ? trigger : 0)
    }

    private var localPlayerImage: Data? { matchManager.localPlayerImage }
    private var otherPlayerImage: Data? { matchManager.localPlayerImage }
    private var xScore: Int { gameLogic.xScore }
    private var oScore: Int { gameLogic.oScore }
    private var localPlayerScore: Int { matchManager.localPlayerScore }
    private var otherPlayerScore: Int { matchManager.otherPlayerScore }
    private var offlineDifference: Double { Double(xScore - oScore) }
    private var onlineDifference: Double { Double(localPlayerScore - otherPlayerScore) }

    private var scaleFactor: Double {

        if view.value == .online {
            return abs(onlineDifference) < 3 ? abs(onlineDifference) : 3 * 0.33
        } else {
            return abs(offlineDifference) < 3 ? abs(offlineDifference) : 3 * 0.33
        }
    }

    private var yOffset: CGFloat {

        if abs(onlineDifference) <= 3 || abs(offlineDifference) <= 3 {

            ySize * -0.003 * (view.value == .online ? abs(onlineDifference) : abs(offlineDifference))
        } else {
            ySize * -0.003 * 3
        }

    }

    var body: some View {
        ZStack {
            CustomRectangle(invert: invert)
                .offset(x: moveWinner(for: xSize))
                .animation(.snappy(duration: 1), value: animationTriggerValue)
                .overlay {
                    Group {
                        if abs(onlineDifference) >= 2.0 || abs(offlineDifference) >= 2.0 {
                            LottieAnimation(
                                name: "Fire",
                                contentMode: .scaleAspectFit,
                                playbackMode: (.playing(.fromFrame(1, toFrame: 25, loopMode: .loop))),
                                scaleFactor: CGFloat(min(scaleFactor, 0.99))
                            )
                            .offset(
                                x: (gameModeScore() ? xSize : -xSize) * 0.25 + moveWinner(for: xSize),
                                y: yOffset
                            )
                            .animation(.snappy(duration: 1), value: animationTriggerValue)
                        }
                    }
                }

            HStack(spacing: 5) {
                if !invert {
                    if view.value == .offline || view.value == .bot {
                        Image("X")
                            .if(device == .phone) { image in
                                image.resizable()
                            }
                            .frame(width: xSize * 0.13, height: xSize * 0.13)
                    } else if view.value == .online {

                        let localPlayer = matchManager.localPlayerImage
                        let otherPlayer = matchManager.otherPlayerImage
                        let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)!

                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: xSize * 0.13, height: xSize * 0.13)
                            .onAppear {
                                print(String(describing: uiImage))
                            }
                    }

                    Text("\(playerScore())")
                        .fontWeight(.bold)
                        .font(device == .pad ? .largeTitle : .title)
                        .multilineTextAlignment(.trailing)
                        .frame(width: xSize * 0.1)

                } else {

                    Text("\(playerScore())")
                        .fontWeight(.bold)
                        .font(device == .pad ? .largeTitle : .title)
                        .multilineTextAlignment(.trailing)
                        .frame(width: xSize * 0.1)

                    if view.value == .offline || view.value == .bot {
                        Image("O")
                            .if(device == .phone) { image in
                                image.resizable()
                            }
                            .frame(width: xSize * 0.13, height: xSize * 0.13)
                    } else {

                        let localPlayer = matchManager.localPlayerImage
                        let otherPlayer = matchManager.otherPlayerImage

                        let uiImage = UIImage(data: ((player == "left" ? localPlayer : otherPlayer) ?? systemImageData(systemName: player == "left" ? "person.circle" : "person.circle.fill"))!)!

                        Image(uiImage: uiImage)
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

        .ignoresSafeArea(.all)
    }

    func gameModeScore() -> Bool {
        if view.value == .online {
            return (localPlayerScore > otherPlayerScore) ? true : false
        } else {
            return (xScore > oScore) ? true : false
        }
    }

    func moveWinner(for value: CGFloat) -> CGFloat {
        let multiplyingFactor = 0.042
        let absOfflineDifference = abs(offlineDifference)
        let absOnlineDifference = abs(onlineDifference)

        let onlineCondition = (absOnlineDifference >= 0 && absOnlineDifference <= 5)
        let offlineCondition = (absOfflineDifference >= 0 && absOfflineDifference <= 5)

        let offlineScore = CGFloat(xScore - oScore) * value * multiplyingFactor
        let onlineScore = CGFloat(localPlayerScore - otherPlayerScore) * value * multiplyingFactor

        let maxOfflineDifference = CGFloat(xScore > oScore ? 5 : -5) * value * multiplyingFactor
        let maxOnlineDifference = CGFloat(localPlayerScore > otherPlayerScore ? 5 : -5) * value * multiplyingFactor

        if view.value == .online {
            return onlineCondition ? onlineScore : maxOnlineDifference
        } else {
            return offlineCondition ? offlineScore : maxOfflineDifference
        }

    }

    func systemImageData(systemName: String) -> Data? {
        let image = UIImage(systemName: systemName)
        return image?.pngData()
    }

    func playerScore() -> Int {

        if view.value == .online {
            return player == "left" ? localPlayerScore : otherPlayerScore
        } else {
            return player == "left" ? xScore : oScore
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
