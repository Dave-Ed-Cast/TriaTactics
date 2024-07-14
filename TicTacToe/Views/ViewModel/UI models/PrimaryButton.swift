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

    let size = UIScreen.main.bounds

    init(label: LocalizedStringKey, action: (() -> Void)? = nil, color: Color = .buttonTheme, invertColor: Bool = false) {
        self.label = label
        self.action = action
        self.color = color
        self.invertColor = invertColor
    }

    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(color)
                    .frame(width: size.width / 2.1, height: size.height / 12)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                Text(label)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(.title)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 30) {
            PrimaryButton(label: "TEST AAAA", action: {})
            PrimaryButton(label: "TEST BBBB", action: {}, color: .red)
            PrimaryButton(label: "TEST CCCC", action: {}, color: .red, invertColor: true)

        }
    }
}
