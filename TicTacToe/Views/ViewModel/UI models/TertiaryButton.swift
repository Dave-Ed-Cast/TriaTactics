//
//  TertiaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 06/07/24.
//

import SwiftUI

struct TertiaryButton: View {

    @State private var doSomething: Bool = false
    let action: (() -> Void)?
    let color: Color
    let invertColor: Bool

    let size = UIScreen.main.bounds

    init(action: (() -> Void)? = nil, color: Color = .buttonTheme, invertColor: Bool = false) {
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
                Circle()
                    .foregroundStyle(color)
                    .frame(width: size.width / 12, height: size.height / 12)
                    .if(invertColor) { view in
                        view.colorInvert()
                    }
                Image(systemName: "xmark")
                    .padding()
                    .foregroundStyle(.textTheme)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black

        VStack(spacing: 20) {
            TertiaryButton()
            TertiaryButton(color: .yellow)
        }
    }

}
