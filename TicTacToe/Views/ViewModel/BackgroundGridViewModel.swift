//
//  BackgroundGridViewModel.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

/// This is the field grid, here go all modifications relating to the grid
struct BackgroundGridViewModel: View {
    var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            let spacing = gridSize * 0.5

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: gridSize, height: gridSize)
                    .foregroundStyle(.yellow)

                VStack(spacing: spacing * 0.65) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(height: gridSize * 0.015)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(height: gridSize * 0.015)
                }
                .frame(width: gridSize)

                HStack(spacing: spacing * 0.65) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: gridSize * 0.014)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: gridSize * 0.014)
                }
            }
            .frame(width: gridSize, height: gridSize, alignment: .center)
        }
    }
}

#Preview {
    BackgroundGridViewModel()
}
