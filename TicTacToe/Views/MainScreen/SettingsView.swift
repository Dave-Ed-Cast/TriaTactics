//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

struct SettingsView: View {

    @Binding var toggleAnimation: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: size.width / 8, height: size.height / 256)
                    .foregroundStyle(Color(.systemGray3))

                Toggle("Toggle Animation", isOn: $toggleAnimation)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray5) : .white)
                    }
                    .onChange(of: toggleAnimation) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "animationStatus")
                    }
            }
            .padding()
            .padding(.bottom, 40)
            .frame(maxWidth: size.width, maxHeight: .infinity, alignment: .center)
            .background(colorScheme == .dark ? .black : .white)
        }
        .background(colorScheme == .dark ? .black : .white)
    }
}

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

                    VStack {
                        Spacer()

                        modalContent()
                            .frame(maxWidth: size.width, maxHeight: size.height * 0.15)
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
                    .transition(.move(edge: .bottom))
                    .frame(maxHeight: size.height, alignment: .bottom)
                }
            }
        }
    }
}

#Preview {
    SettingsView(toggleAnimation: .constant(true))
}

#Preview {
    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
    }
}
