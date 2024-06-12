//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI

/// This is the game grid, here go all modifications relating to cell position of symbols
struct GameGrid: View {
    
    @ObservedObject var matchManager: MatchManager
    @ObservedObject var gameLogic: GameLogic
    
    @State private var showLottieAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            let cellSize = gridSize / 4
            
            ZStack {
                VStack(spacing: gridSize * 0.075) {
                    ForEach(0..<3) { row in
                        HStack(spacing: gridSize * 0.081) {
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
                )
                .overlay {
                    if gameLogic.isGameOver ?? false {
                        GameOver(gameLogic: gameLogic, showLottieAnimation: $showLottieAnimation)
                            .frame(width: gridSize, height: gridSize)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    GameGrid(matchManager: MatchManager(), gameLogic: GameLogic())
}
