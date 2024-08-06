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
        ZStack {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.height / 256)
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
            .background(colorScheme == .dark ? .black : .white)
            .padding()
            .padding(.bottom, 40)
        }
        .background(colorScheme == .dark ? .black : .white)
    }
}

struct HalfModalView<ModalContent: View>: ViewModifier {

    @Environment(\.dismiss) var dismiss

    @Binding var isPresented: Bool

    @State private var offset: CGSize = .zero

    let modalContent: () -> ModalContent
    let maxHeight: CGFloat = UIScreen.main.bounds.height / 256

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

                VStack {
                    Spacer()

                    modalContent()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .offset(y: isPresented ? max(0, offset.height) : UIScreen.main.bounds.height)
                        .onAppear {
                            offset.height = 0
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { value in
                                    withAnimation {
                                        if value.translation.height > 0 {
                                            isPresented = false
                                        }
                                    }
                                }
                        )
                }
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.bottom)
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
