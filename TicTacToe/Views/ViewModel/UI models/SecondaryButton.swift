//
//  SecondaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct SecondaryButton: View {

    @State private var doSomething: Bool = false
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
            doSomething = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(color)
                    .frame(width: size.width / 3, height: size.height / 16)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                Text(label)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black

        VStack(spacing: 20) {
            PrimaryButton(label: "TEST AAAA")
            PrimaryButton(label: "TEST BBBB")
            SecondaryButton(label: "TEST AAAA")
            SecondaryButton(label: "TEST BBBB", color: .yellow)
        }
    }

}
