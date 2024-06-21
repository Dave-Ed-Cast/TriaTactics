//
//  PrimaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PrimaryButton: View {

    @Binding var showSomething: Bool
    let buttonText: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            showSomething = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.yellow)
                    .frame(minWidth: 50, idealWidth: 200, maxWidth: 200, minHeight: 50, idealHeight: 70, maxHeight: 70)
                Text(buttonText)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                    .font(.title)
            }
        }
    }
}

#Preview {
    PrimaryButton(showSomething: .constant(true), buttonText: "TEST AAAAAA", action: {})
}
