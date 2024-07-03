//
//  PrimaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PrimaryButton: View {

    @State private var showSomething: Bool = false
    let label: LocalizedStringKey
    let action: (() -> Void)?

    var body: some View {
        Button {
            action!()
            showSomething = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(minWidth: 50, idealWidth: 200, maxWidth: 200, minHeight: 50, idealHeight: 70, maxHeight: 70)
                Text(label)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                    .font(.title)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black

        PrimaryButton(label: "TEST AAAAAA", action: {})
            .background(.black)
    }
}
