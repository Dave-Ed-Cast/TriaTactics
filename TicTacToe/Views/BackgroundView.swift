//
//  BackgroundView.swift
//  TicTacToe
//
//  Created by Giuseppe Francione on 21/06/24.
//

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

    let widthScreen: CGFloat = UIScreen.main.bounds.width
    let heightScreen: CGFloat = UIScreen.main.bounds.height
    let gridSize: CGFloat = 30
    let columns: Array = Array(repeating: GridItem(.flexible()), count: 13)

    @State private var yOffset: CGFloat = 0

    var body: some View {
        VStack {
            animatedImage
                .frame(width: widthScreen, height: heightScreen)
                .background(.backgroundTheme)
                .rotationEffect(.degrees(-15))
                .scaleEffect(1.8)
                .onAppear {
                    startScrolling()
                }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var animatedImage: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<259) { i in
                Image(i % 2 == 0 ? "X" : "O")
                    .interpolation(.none)
                    .resizable()
                    .frame(width: gridSize, height: gridSize)
                    .padding(.vertical, -2)
                    .opacity(0.08)
            }
        }
        .offset(y: yOffset)
    }

    private func startScrolling() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            yOffset = -68
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
