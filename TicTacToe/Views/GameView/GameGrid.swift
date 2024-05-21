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
    
    @State private var start: Date = Date.now
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 350)
                .foregroundStyle(.yellow)
            VStack(spacing: 105) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(height: 6)
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(height: 6)
            }
            .frame(width: 350, height: 100)
            
            HStack(spacing: 125) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 6)
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 6)
            }
            .frame(width: 100, height: 340)
            
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
                LottieAnimation(name: "GameOver", contentMode: .center, playbackMode: .playing(.toProgress(1, loopMode: .playOnce)))
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(20)
                    .padding()
            }
        }
    }
}

#Preview {
    GameGrid(gameLogic: GameLogic())
}
