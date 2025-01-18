//
//  BackgroundView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

import SwiftUI

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

struct BackgroundView: View {

    let device = UIDevice.current.userInterfaceIdiom
    let widthScreen: CGFloat = UIScreen.main.bounds.width
    let heightScreen: CGFloat = UIScreen.main.bounds.height
    let gridSize: CGFloat = 30
    let numberOfIterations = 283

    @Binding var savedValueForAnimation: Bool
    @State private var yOffset: CGFloat = 0

    var body: some View {
        VStack {
            let columns: Array = Array(repeating: GridItem(.flexible()), count: device == .pad ? 27 : 13)
            let iterations = device == .pad ? numberOfIterations * 3 : numberOfIterations
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
            .scaleEffect(1.47)
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
