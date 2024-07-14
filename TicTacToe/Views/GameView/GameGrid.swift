//
//  Grid.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

import SwiftUI
import UIKit

/// This is the game grid, here go all modifications relating to cell position of symbols
struct GameGrid: View {

    @ObservedObject var gameLogic: GameLogic

    @State private var showLottieAnimation = false

    var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            let cellSize = gridSize / 4
            let borderEdge = 0.90
            let gridFactorY = 0.081
            let gridFactorX = 0.085

            ZStack {
                VStack(spacing: gridSize * gridFactorY * borderEdge) {
                    ForEach(0..<3) { row in
                        HStack(spacing: gridSize * gridFactorX * borderEdge) {
                            ForEach(0..<3) { col in
                                let index = row * 3 + col
                                Button {
                                    gameLogic.buttonTap(index: index)
                                    performHapticFeedback()
                                } label: {
                                    Image(gameLogic.buttonLabel(index: index))
                                        .renderingMode(.template)
                                        .interpolation(.none)
                                        .resizable()
                                        .frame(width: cellSize * borderEdge, height: cellSize * borderEdge)
                                        .animation(.default, value: gameLogic.buttonLabel(index: index))
//                                        .foregroundStyle(gameLogic.buttonColor(index: index))
                                        .foregroundStyle(.textTheme)

                                }
                            }
                        }
                    }
                }
                .frame(width: gridSize * borderEdge, height: gridSize * borderEdge)
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

    func performHapticFeedback() {
        var generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        generator = UIImpactFeedbackGenerator(style: .rigid)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            generator.impactOccurred()
        }
    }
}

#Preview {
    GameGrid(gameLogic: GameLogic.shared)
}

#Preview("Gameview") {
    GameView()
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
        .environmentObject({
            let navigation = Navigation.shared
            navigation.value = .offline
            return navigation
        }())
}
