//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameGrid: View {
    
    
    @ObservedObject var gameLogic: GameLogic
    
    let col = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var showLottieAnimation = false
    
    var body: some View {
        ZStack {
            BackgroundGridViewModel()
            
            VStack(spacing: 30) {
                ForEach(0..<3) { row in
                    HStack(spacing: 40) {
                        ForEach(0..<3) { col in
                            let index = row * 3 + col
                            Button {
                                gameLogic.buttonTap(index: index)
                            } label: {
                                Image(gameLogic.buttonLabel(index: index))
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
            
            if gameLogic.isGameOver ?? false {
                ZStack {
                    LottieAnimation(name: "Line", contentMode: .scaleAspectFit, playbackMode: .playing(.fromFrame(1, toFrame: 26, loopMode: .playOnce)), scaleFactor: 8, degrees: gameLogic.degrees, offset: gameLogic.offsetPosition)
                    if showLottieAnimation {
                        LottieAnimation(name: "GameOver", contentMode: .center, playbackMode: .playing(.toProgress(1, loopMode: .playOnce)))
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(20)
                            .padding()
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        withAnimation {
                            showLottieAnimation = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GameGrid(gameLogic: GameLogic())
}
