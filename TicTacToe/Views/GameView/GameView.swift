//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var view: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false
    @State private var scale: CGFloat = 1.0
    @State private var timer: Timer?
    @State private var start: Date = Date.now

    var body: some View {

        ZStack {
            Color.buttonTheme.ignoresSafeArea()

            VStack(spacing: -15) {

                TopHUD()
                ScoreView()

                Spacer()
                VStack {
                    if view.value == .online {
                        Text("Time left: \(matchManager.remainingTime)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity((view.value == .offline) ? 0 : 1)
                            .foregroundStyle(matchManager.remainingTime <= 3 ? .red : .textTheme)
                            .padding(.top, 10)

                    } else if view.value == .offline || view.value == .bot {
                        // TODO: picker for difficulty
                        Text("Ascanio placeholder")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.textTheme)
                            .padding(.top, 10)
                            .opacity(0)
                    }
                }

                GameGrid(gameLogic: gameLogic)

                Spacer()
                Group {

                    let localPlayer = matchManager.localPlayer.displayName
                    let otherPlayer = matchManager.otherPlayer?.displayName
                    let localPlayerScore = matchManager.localPlayerScore

                    if view.value == .online {
                        Text("\(localPlayerScore >= 3 ? (localPlayer) : (otherPlayer ?? "other")) is on a roll!")
                            .fontWeight(.bold)
                    } else if view.value == .offline {
                        Text("\(gameLogic.xScore >= 2 ? "X player" : "O player") is on a roll!")
                            .fontWeight(.bold)
                    } else {
                        Text("\(gameLogic.xScore >= 2 ? "Player" : "AI") is on a roll!")
                            .fontWeight(.bold)

                    }

                }

                .foregroundStyle(.textTheme)
                .font(.title3)
                .scaleEffect(scale)
                .opacity(showPlayerRoll())
                .onAppear {
                    startScalingAnimation()
                }
                .onDisappear {
                    timer?.invalidate()
                }
            }

        }// end of outer VStack

        .onAppear {
            gameLogic.resetGame()
            gameLogic.xScore = 0
            gameLogic.oScore = 0
        }
        .onDisappear {
            matchManager.gameOver()
        }
        .onChange(of: gameLogic.winner) { newValue in
            if newValue != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation(.easeIn(duration: 0.7)) {
                        showWinnerOverlay = true
                    }
                }
            }
        }

        if showWinnerOverlay {
            WinnerView()
                .onChange(of: gameLogic.winner) { newValue in
                    if newValue == nil { showWinnerOverlay = false }
                }
        }
    }// end of outer ZStack

    func showPlayerRoll() -> Double {

        let offlineDifference = abs(gameLogic.xScore - gameLogic.oScore)
        let onlineDifference = abs(matchManager.localPlayerScore - matchManager.otherPlayerScore)

        if view.value == .online {
            return onlineDifference >= 3 ? 1 : 0
        } else {
            return offlineDifference >= 3 ? 1 : 0
        }
    }

    func startScalingAnimation() {

        timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
            withAnimation {
                scale = (scale == 1.0) ? 0.85 : 1.0
            }
        }
    }

    func iOSVersion() -> Bool {
        if #available(iOS 17.0, *) { return true }
        return false
    }
}

#Preview("Offline") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("Online") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}

#Preview("AI") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
