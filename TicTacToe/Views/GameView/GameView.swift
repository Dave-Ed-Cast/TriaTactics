//
//  GameView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct GameView: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic = GameLogic()
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var isOffline: Bool
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            
        }
        .overlay(alignment: .topTrailing) {
            if !isOffline {
                backToMenuView
                    .padding()
                    .padding(.top, 15)
            }
        }
        Group {
            VStack {
                Text("Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                Text("Time left: \(isOffline ? 0 : matchManager.remainingTime)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .opacity(isOffline ? 0 : 1)
                    .padding()
                Spacer()
                HStack {
                    if isOffline {
                        Text("Your turn: \(gameLogic.activePlayer == .X ? "X" : "O")")
                            .fontWeight(.bold)
                    } else {
                        Text("\(matchManager.currentlyPlaying ? matchManager.localPlayer.displayName : matchManager.otherPlayer!.displayName) turn")
                            .fontWeight(.bold)
                            .foregroundStyle(matchManager.currentlyPlaying ? .blue : .red)
                    }
                        
                }
                .font(.title2)
                .padding()
                .padding(.bottom, 60)
                .overlay(
                    winnerView
                        .offset(y: 30)
                )
            }
            .foregroundStyle(.black)
            
            scoreView
            
            GameGrid(matchManager: matchManager, gameLogic: gameLogic)
                .padding()
            
            buttonView
            
        }
        .onAppear {
            gameLogic.resetGame()
            gameLogic.isOffline = isOffline
        }
        .onReceive(countdownTimer) { _ in
            guard matchManager.isTimeKeeper else { return }
            matchManager.remainingTime -= 1
        }
        
    }
    
    var winnerView: some View {
        Group {
            if let winner = gameLogic.winner {
                if isOffline {
                    Text("\(winner.rawValue) wins!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                } else {
                    if matchManager.localPlayerWin {
                        Text("You Lose!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    } else {
                        Text("You Win!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
    var scoreView: some View {
        HStack(spacing: 80) {
            Text("Your wins: \(isOffline ? 2 : matchManager.localPlayerScore)")
            Text("Opponent wins: \(isOffline ? 2 : matchManager.otherPlayerScore)")
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
                        gameLogic.resetGame()
                        matchManager.resetGame()
                    }
                }
            }
        } label: {
            Text("Restart?")
                .fontWeight(.medium)
                .frame(width: 200, height: 70, alignment: .center)
                .background(.yellow)
                .foregroundStyle(.black)
                .font(.title3)
                .cornerRadius(20)
        }
        .opacity(gameLogic.checkWinner() ? 1 : 0.5)
        .disabled(!gameLogic.checkWinner())
        .padding()
    }
    var backToMenuView: some View {
            Button(action: {
                showAlert = true
            }) {
                ZStack {
                    Circle()
                        .scaledToFit()
                        .foregroundColor(.yellow)
                    Text("X")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .frame(width: 30, height: 30)
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
