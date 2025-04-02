//
//  HalfModalView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 18/01/25.
//

import SwiftUI

struct HalfModalView<ModalContent: View>: ViewModifier {

    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool

    @State private var offset: CGSize = .zero

    let modalContent: () -> ModalContent

    func body(content: Content) -> some View {
        ZStack {
            content
                .onDisappear {
                    isPresented = false
                }

            if isPresented {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                GeometryReader { geometry in
                    let size = geometry.size
                    let modalWidth = size.width
                    let modalHeight = size.height * 0.15
                    VStack {
                        Spacer()

                        modalContent()
                            .frame(maxWidth: modalWidth, maxHeight: modalHeight)
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .offset(y: isPresented ? max(0, offset.height) : size.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = value.translation
                                    }
                                    .onEnded { value in
                                        withAnimation {
                                            if value.translation.height > 50 {
                                                isPresented = false
                                            }
                                            offset = .zero
                                        }
                                    }
                            )
                    }
                    .transition(.customPush(cfrom: .bottom))
                    .frame(maxHeight: size.height, alignment: .bottom)
                }
            }
        }
    }
}
