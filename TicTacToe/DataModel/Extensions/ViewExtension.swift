//
//  CustomPushTransitionModifier.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func halfModal<ModalContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ModalContent) -> some View {
        self.modifier(HalfModalView(isPresented: isPresented, modalContent: content))
    }

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

extension AnyTransition {
    static func customPush(cfrom edge: Edge) -> AnyTransition {
        if #available(iOS 16.0, *) {
            return .push(from: edge)
        } else {
            return .modifier(
                active: PushTransition(isActive: true, direction: edge),
                identity: PushTransition(isActive: false, direction: edge)
            )
        }
    }
}
