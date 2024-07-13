//
//  WinnerView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 13/07/24.
//

import SwiftUI

struct WinnerView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var changeViewTo: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 20) {

                VStack {
                    Text("The winner is:")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.textTheme)

                    if changeViewTo.value == .offline || changeViewTo.value == .bot {
                        Image(gameLogic.winner?.rawValue ?? "")
                            .resizable()
                            .frame(maxWidth: 130, maxHeight: 130)
                    } else {
                        Text(matchManager.localPlayerWin ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundStyle(.textTheme)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.buttonTheme.opacity(0.8))
                        .shadow(radius: 10)
                }
                .padding(.top, 150)

                PrimaryButton(label: "Rematch", action: {

                    if changeViewTo.value == .offline || changeViewTo.value == .bot {
                        gameLogic.resetGame()
                    } else {
                        matchManager.sendRematchRequest()
                    }
                    withAnimation(.easeIn(duration: 0.5)) {
                        showWinnerOverlay = false
                    }
                }, color: .buttonTheme.opacity(0.8))

                PrimaryButton(label: "Menu", action: {
                    showAlert = true
                }, color: .buttonTheme.opacity(0.8))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Quit game?"),
                        message: Text("Are you sure you want to leave?"),
                        primaryButton: .destructive(Text("Yes")) {

                            withAnimation(.easeOut(duration: 0.5)) {
                                changeViewTo.value == .online ? (matchManager.gameOver()) : (changeViewTo.value = .play)
                            }

                            showAlert = false

                        },
                        secondaryButton: .cancel()
                    )
                }
                .preferredColorScheme(colorScheme)
            }
            .onChange(of: gameLogic.activePlayer) { activePlayer in
                if activePlayer == .O && changeViewTo.value == .bot {
                    gameLogic.computerMove()
                }
            }
        }
    }

}

#Preview("offline") {
    WinnerView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("AI") {
    WinnerView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
