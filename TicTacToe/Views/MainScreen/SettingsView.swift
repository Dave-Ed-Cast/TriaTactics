//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

struct SettingsView: View {

    @Binding var toggleAnimation: Bool

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.device) private var device

    let size = UIScreen.main.bounds.size

    var body: some View {

        let hintRectangleWidth = size.width / 8
        let hintRectangleHeight = size.height / 256
        ZStack {
            VStack(spacing: 20) {
                Group {
                    if device == .pad {
                        VStack {

                            Toggle("Toggle Animation", isOn: $toggleAnimation)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(colorScheme == .dark ? Color(.systemGray5) : .white)
                                }
                                .onChange(of: toggleAnimation) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "animationStatus")
                                }
                            Spacer()
                            SecondaryButton("Confirm") {
                                dismiss()
                            }
                        }
                    } else if device == .phone {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: hintRectangleWidth, height: hintRectangleHeight)
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
                }
            }
            .padding()
            .padding(.bottom, 40)
            .frame(maxWidth: size.width, maxHeight: .infinity, alignment: .center)
            .background(colorScheme == .dark ? .black : .white)
        }
        .background(colorScheme == .dark ? .black : .white)
        .transition(.customPush(cfrom: .top))
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
