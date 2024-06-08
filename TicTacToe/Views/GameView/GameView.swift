//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var matchManager: MatchManager = MatchManager()
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    @Binding var isOffline: Bool
    
    @State private var showAlert = false
    
    var body: some View {
        
//        NavigationView {
//            
//        }
//        .overlay(alignment: .topTrailing) {
//            if !isOffline {
//                backToMenuView
//                    .padding()
//                    .padding(.top, 20)
//            }
//        }
        VStack {
            VStack {
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Time left: \(matchManager.remainingTime)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(isOffline ? 0 : 1)
                    .padding()
            }
            .padding(.top, 40)
            
            HStack {
                if isOffline {
                    Text("Your turn: \(gameLogic.activePlayer == .X ? "X" : "O")")
                        .font(.title3)
                        .fontWeight(.bold)
                } else {
                    Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer!.displayName) turn")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(matchManager.currentlyPlaying ? .blue : .red)
                }
            }
            
            .overlay(
                winnerView
                    .offset(y: 20)
            )
            
            scoreView
            
                .padding(.bottom, 30)
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding(.horizontal, 20)
            buttonView
                .padding(.bottom, 30)
            
        }
        .foregroundStyle(.black)
        .onAppear {
            gameLogic.resetGame()
            gameLogic.isOffline = isOffline
        }
        .onDisappear {
            matchManager.gameOver()
        }
    }
    
    var winnerView: some View {
        Group {
            if let winner = gameLogic.winner {
                if isOffline {
                    Text("\(winner.rawValue) wins!")
                        .fontWeight(.bold)
                } else {
                    Text(matchManager.localPlayerWin ? "You win!" : "You Lose!")
                        .fontWeight(.bold)
                }
            }
        }
        .font(.title)
        .padding(.bottom, 20)
    }
    
    var scoreView: some View {
        HStack(spacing: 80) {
            if !isOffline {
                Text("Your wins: \(matchManager.localPlayerScore)")
                Text("Opponent wins: \(matchManager.otherPlayerScore)")
            }
        }
        .font(.callout)
    }
    
    var buttonView: some View {
        Button {
            if isOffline {
                if gameLogic.checkWinner() {
                    gameLogic.resetGame()
                }
            } else {
                if gameLogic.checkWinner() {
                    withAnimation {
                        matchManager.sendRematchRequest()
                    }
                }
            }
        } label: {
            Text("Rematch?")
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .font(.title3)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0)
        .disabled(!gameLogic.checkWinner())
        .padding(.vertical, 30)
    }
    
    var backToMenuView: some View {
        Button(action: {
            showAlert = true
        }) {
            Text("hi")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Quit game?"),
                message: Text("Are you sure you want to leave?"),
                primaryButton: .destructive(Text("Yes")) {
                    matchManager.gameOver()
                    showAlert = false
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    //setting offline = false crashes the preview due to Text(match manager)
    GameView(matchManager: MatchManager(), isOffline: .constant(true))
}
