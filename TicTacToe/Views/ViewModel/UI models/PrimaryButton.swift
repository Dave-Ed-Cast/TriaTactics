//
//  PrimaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PrimaryButton: View {

    let label: LocalizedStringKey
    let action: (() -> Void)?
    let color: Color
    let invertColor: Bool
    let animation: AnimationTap?
    let size = UIScreen.main.bounds

    init(label: LocalizedStringKey, action: (() -> Void)? = nil, color: Color = .buttonTheme, invertColor: Bool = false, animation: AnimationTap = AnimationTap.init()) {
        self.label = label
        self.action = action
        self.color = color
        self.invertColor = invertColor
        self.animation = animation
    }

    var body: some View {
        Button {
            if let animation = animation {
                print("aaa")
                animation.shouldAnimate = true
            }
            action?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(color)
                    .frame(width: size.width / 2, height: size.height / 14)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 15))

                Text(label)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(.title2)
                    .multilineTextAlignment(.center)

            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 30) {
            PrimaryButton(label: "orland shbienen", action: {})
            PrimaryButton(label: "TEST BBBB", action: {}, color: .red)
            PrimaryButton(label: "TEST CCCC", action: {}, color: .red, invertColor: true)

        }
    }
}
