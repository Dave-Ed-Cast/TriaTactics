//
//  PlayView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PlayView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var changeViewTo: Navigation

    @State private var isOffline: Bool = false
    @State private var showGameView: Bool = false

    var body: some View {
        Spacer()
        VStack(spacing: 30) {
                PrimaryButton(label: "Play Online", action: {
                    //                if matchManager.inGame && matchManager.autheticationState == .authenticated {
                    // MARK: This if statement was for showing the game view
                    matchManager.startMatchmaking()
                    if matchManager.matchFound {
                        changeViewTo.value = .online
                    }
                })
                .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.autheticationState != .authenticated)
                
                PrimaryButton(label: "Play Offline", action: { changeViewTo.value = .offline })
            
            }
        .padding(.top, 100)
        .onAppear {
            matchManager.authenticateUser()
        }
        Spacer()
        SecondaryButton(label: "Menu", action: { changeViewTo.value = .main })

    }

    //                    if matchManager.inGame && matchManager.autheticationState == .authenticated {
    //                GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
    //                changeViewTo.value = .online

    //            } else {

    //            matchManager.startMatchmaking()

    //            if matchManager.matchFound {
    //                        if isOffline {
    //                            changeViewTo.value = .offline
    //                        }
    //                showGameView = true
    //            }

}

#Preview {
    PlayView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
