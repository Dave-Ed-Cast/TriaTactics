//
//  PrimaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PrimaryButton: View {

    @State private var doSomething: Bool = false
    let label: LocalizedStringKey
    let action: (() -> Void)?
    let color: Color

    init(label: LocalizedStringKey, action: (() -> Void)? = nil, color: Color = .buttonTheme.opacity(0.8)) {
        self.label = label
        self.action = action
        self.color = color
    }

    var body: some View {
        Button {
            action?()
            doSomething = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(color)
                    .frame(minWidth: 50, idealWidth: 200, maxWidth: 200, minHeight: 50, idealHeight: 70, maxHeight: 70)
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

        VStack(spacing: 20) {
            PrimaryButton(label: "TEST AAAAAA", action: {})
            PrimaryButton(label: "TEST BBBBBB", action: {}, color: .red)
        }
    }
}
