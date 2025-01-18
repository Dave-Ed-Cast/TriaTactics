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
    @EnvironmentObject var view: Navigation

    @Environment(\.colorScheme) var colorScheme

    @State private var showAlert = false
    @State private var showWinnerOverlay = false
    @State private var pressed = false

    let xSize = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 20) {

                VStack {
                    Text("The winner is:")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.textTheme)

                    if view.value == .offline || view.value == .bot {
                        Image(gameLogic.winner?.rawValue ?? "")
                            .resizable()
                            .frame(maxWidth: 130, maxHeight: 130)
                    } else {
                        VStack {
                            let localPlayer = matchManager.localPlayerImage
                            let otherPlayer = matchManager.otherPlayerImage
                            let data = matchManager.localPlayerWin ? localPlayer : otherPlayer
                            let uiImage = UIImage(data: (data ?? systemImageData(systemName: gameLogic.winner?.rawValue == "X" ? "person.circle" : "person.circle.fill"))!)

                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: xSize * 0.265, height: xSize * 0.265)

                            Text(matchManager.localPlayerWin ? matchManager.localPlayer.displayName : matchManager.otherPlayer?.displayName ?? "Other")
                                .font(.headline)
                                .foregroundStyle(.textTheme)
                        }
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

                PrimaryButton("Rematch") {

                    if view.value == .offline || view.value == .bot {
                        gameLogic.resetGame()
                    } else {
                        matchManager.sendRematchRequest()
                    }
                    withAnimation(.easeIn(duration: 0.5)) {
                        showWinnerOverlay = false
                    }
                }

                PrimaryButton("Menu") {
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Quit game?"),
                        message: Text("Are you sure you want to leave?"),
                        primaryButton: .destructive(Text("Yes")) {

                            withAnimation(.easeOut(duration: 0.5)) {
                                view.value == .online ? (matchManager.gameOver()) : (view.value = .play)
                            }

                            showAlert = false

                        }, secondaryButton: .cancel()
                    )
                }
                .preferredColorScheme(colorScheme)
            }
            .onChange(of: gameLogic.activePlayer) { player in
                if player == .O && view.value == .bot {
                    gameLogic.computerMove()
                }
            }
        }

    }

    func systemImageData(systemName: String) -> Data? {
        let image = UIImage(systemName: systemName)
        return image?.pngData()
    }
}

#Preview("offline") {
    WinnerView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
#Preview("online") {
    WinnerView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .online
            return navigation
        }())
}
#Preview("AI") {
    WinnerView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .bot
            return navigation
        }())
}
