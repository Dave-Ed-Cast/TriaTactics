//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

struct SettingsView: View {

    @Binding var isAnimationEnabled: Bool

    var body: some View {
        ZStack {
            Toggle("Enable Animation", isOn: $isAnimationEnabled)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.buttonTheme.opacity(0.8))
            }
            .padding()
            .onChange(of: isAnimationEnabled) { newValue in
                UserDefaults.standard.set(newValue, forKey: "animationStatus")
            }
        }
    }
}

struct HalfModalView<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let modalContent: () -> ModalContent

    func body(content: Content) -> some View {
        ZStack {
            content

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
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
                        .animation(.spring(), value: isPresented)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

#Preview {
    SettingsView(isAnimationEnabled: .constant(true))
}
