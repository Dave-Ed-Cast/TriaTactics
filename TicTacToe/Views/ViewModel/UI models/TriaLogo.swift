//
//  TriaLogo.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 03/01/25.
//

import SwiftUI

struct TriaLogo: View {

    @EnvironmentObject private var view: Navigation

    let device = UIDevice.current.userInterfaceIdiom
    let size = UIScreen.main.bounds.size

    var namespace: Namespace.ID

    var body: some View {
        let containerSize = device == .pad ? size.height * 0.4 : size.height * 0.134

        VStack(spacing: 5) {

            Image("appicon")
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding(30)
            VStack(spacing: 5) {
                Text(verbatim: "Tria Tactics")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("The game for true tacticians!")
                    .font(device == .pad ? .title2 : .headline)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .foregroundStyle(.textTheme)
        .padding()
        .background {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.buttonTheme.opacity(0.8))
                Button {
                    view.value = .collaborators
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.buttonTheme)
                        .font(device == .pad ? .title : .title3)
                        .colorInvert()
                }
                .padding()
            }
        }
        .matchedGeometryEffect(id: "icon", in: namespace)
        .frame(width: containerSize, height: containerSize)
    }

}

#Preview {
    TriaLogo(namespace: Namespace().wrappedValue)
}
