//
//  BackgroundGridViewModel.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct BackgroundGridViewModel: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let gridSize = min(width, height) * 1.1
            let spacing = gridSize / 3.25
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: gridSize, height: gridSize)
                    .foregroundStyle(.yellow)
                
                VStack(spacing: spacing) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(height: gridSize * 0.02)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(height: gridSize * 0.02)
                }
                .frame(width: gridSize, height: spacing * 2)
                
                HStack(spacing: spacing * 1.1) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: gridSize * 0.014)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: gridSize * 0.014)
                }
                .frame(width: spacing * 2.2, height: gridSize)
            }
            .frame(width: width, height: height, alignment: .center)
        }
    }
}

#Preview {
    BackgroundGridViewModel()
}
