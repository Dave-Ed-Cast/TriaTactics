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
        format.scale = 3
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }

    func snapshot() -> UIImage {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: targetSize)

            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }

}

struct BackgroundView: View {
    @State var yAnimation: Double = 100.0
    @State var xAnimation: Double = 100.0

    let widthScreen: Double = UIScreen.main.bounds.width
    let heightScreen: Double = UIScreen.main.bounds.height

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 13)) {
            ForEach(0..<999) { i in
                Image(i % 2 == 0 ? "X" : "O")
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.vertical, -2)
                    .opacity(0.1)
            }
        }
        .frame(width: widthScreen, height: heightScreen)
        .background(Color.yellow)
        .ignoresSafeArea()
        .rotationEffect(.degrees(-15))
        .scaleEffect(1.8)
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                yAnimation *= 3.0
                xAnimation *= 1.1
            }
        }
        .offset(x: xAnimation, y: yAnimation)
    }

}
#Preview {
    BackgroundView()
}
