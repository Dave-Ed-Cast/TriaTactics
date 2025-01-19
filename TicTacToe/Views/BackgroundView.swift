//
//  BackgroundView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

struct BackgroundView: View {

    @Environment(\.device) private var device

    let widthScreen: CGFloat = UIScreen.main.bounds.width
    let heightScreen: CGFloat = UIScreen.main.bounds.height
    let gridSize: CGFloat = 30
    let numberOfIterations = 283

    @Binding var savedValueForAnimation: Bool
    @State private var yOffset: CGFloat = 0

    var body: some View {
        let count = device == .pad ? 28 : 13
        let columns: Array = Array(repeating: GridItem(.flexible()), count: count)
        let iterations = device == .pad ? numberOfIterations * 3 : numberOfIterations

        VStack {
            LazyVGrid(columns: columns) {
                ForEach(0..<iterations) { i in
                    Image(i % 2 == 0 ? "X" : "O")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: gridSize, height: gridSize)
                        .padding(.vertical, -2)
                        .opacity(0.08)
                }
            }
            .offset(y: yOffset)
            .frame(width: widthScreen, height: heightScreen)
            .background(.backgroundTheme)
            .rotationEffect(.degrees(-15))
            .scaleEffect(device == .pad ? 1.8 : 1.47)
            .onAppear {
                if savedValueForAnimation {
                    startScrolling()
                }
            }
            .onChange(of: savedValueForAnimation) { newValue in
                newValue ? startScrolling() : stopScrolling()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func startScrolling() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            yOffset = -68
        }
    }

    private func stopScrolling() {
        withAnimation(.easeOut(duration: 1)) {
            yOffset = 0
        }
    }
}

#Preview {
    BackgroundView(savedValueForAnimation: .constant(true))
}
