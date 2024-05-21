//
//  BackgroundGridViewModel.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct BackgroundGridViewModel: View {
    var body: some View {
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
    }
}

#Preview {
    BackgroundGridViewModel()
}
