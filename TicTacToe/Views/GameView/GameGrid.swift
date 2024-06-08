//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

struct GameGrid: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic
    
    @State private var showLottieAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            let cellSize = gridSize / 4 // Adjust cell size based on available space

            VStack(spacing: gridSize * 0.08) {
                ForEach(0..<3) { row in
                    HStack(spacing: gridSize * 0.09){
                        ForEach(0..<3) { col in
                            let index = row * 3 + col
                            Button {
                                gameLogic.buttonTap(index: index)
                            } label: {
                                Image(gameLogic.buttonLabel(index: index))
                                    .interpolation(.none)
                                    .resizable()
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }
            .frame(width: gridSize, height: gridSize)
            .background(
                BackgroundGridViewModel()
                    .frame(width: gridSize, height: gridSize)
            )
            .overlay {
                // Conditionally overlay the GameOver view
                if gameLogic.isGameOver ?? false {
                    GameOver(gameLogic: gameLogic, showLottieAnimation: $showLottieAnimation)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        
        
    }
}

#Preview {
    GameGrid(matchManager: MatchManager(), gameLogic: GameLogic())
}
