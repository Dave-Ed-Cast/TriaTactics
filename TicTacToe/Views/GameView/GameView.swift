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

    private var localPlayer: String { matchManager.localPlayer.displayName }
    private var otherPlayer: String { matchManager.otherPlayer?.displayName ?? "Other" }
    private var localPlayerScore: Int { matchManager.localPlayerScore }
    private var otherPlayerScore: Int { matchManager.otherPlayerScore }
    private var xScore: Int { gameLogic.xScore }
    private var oScore: Int { gameLogic.oScore }

    private var resultingPlayer: String {
        switch view.value {
        case .online:
            return localPlayerScore >= 2 ? localPlayer : (otherPlayer)
        case .offline:
            return xScore >= 2 ? "X Player" : "O Player"
        case .bot:
            return xScore >= 2 ? "Player" : "AI"
        default:
            return ""
        }
    }

    var body: some View {

        Group {
            VStack(spacing: 15) {

                TopHUD()
                    .padding(.horizontal)
                ScoreView()
                    .padding(.horizontal)

                VStack {
                    if view.value == .online {
                        Text("Time left: \(matchManager.remainingTime)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity((view.value == .offline) ? 0 : 1)
                            .foregroundStyle(matchManager.remainingTime <= 3 ? .red : .textTheme)
                            .padding(.top, 10)

                    } else {
                        // TODO: picker for difficulty
                        Text(verbatim: "Ascanio placeholder")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.textTheme)
                            .padding(.top, 10)
                            .opacity(0)

                    }
                }
                .frame(alignment: .center)
                VStack {
                    GameGrid(gameLogic: gameLogic)
                        .environmentObject(matchManager)
                        .padding()
//                    TimelineView(.animation) { tl in
//                        let time = start.distance(to: tl.date)
                        Text("\(resultingPlayer) is on a roll!")
                            .fontWeight(.bold)
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
//                            .rainbowEffect(time: time)
//                    }
                }
                Spacer()

            }

        }// end of outer VStack
        .background(.buttonTheme).ignoresSafeArea()
        .overlay {
            if showWinnerOverlay {
                WinnerView()
                    .onChange(of: gameLogic.winner) { newValue in
                        if newValue == nil { showWinnerOverlay = false }
                    }
            }
        }
        .onAppear {
            gameLogic.resetGame()
//            gameLogic.xScore = 0
//            gameLogic.oScore = 0
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

    }

    func showPlayerRoll() -> Double {

        let offlineDifference = abs(xScore - oScore)
        let onlineDifference = abs(localPlayerScore - otherPlayerScore)

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
