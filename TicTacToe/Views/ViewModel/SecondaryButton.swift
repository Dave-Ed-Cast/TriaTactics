//
//  SecondaryButton.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct SecondaryButton: View {

    @State private var showSomething: Bool = false
    let label: LocalizedStringKey
    var action: (() -> Void)?

    var body: some View {
        Button {
            action!()
            showSomething = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.buttonTheme.opacity(0.8))
//                    .foregroundStyle(.yellow)
                    .frame(minWidth: 50, idealWidth: 80, maxWidth: 130, minHeight: 30, idealHeight: 50, maxHeight: 50)
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
        SecondaryButton(label: "TEST AAAA")
            .background(.black)
    }

}
