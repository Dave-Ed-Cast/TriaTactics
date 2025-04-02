//
//  TriaLogo.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 03/01/25.
//

import SwiftUI

struct TriaLogo: View {

    @EnvironmentObject private var view: Navigation

    @Environment(\.device) private var device
    let size = UIScreen.main.bounds.size

    var namespace: Namespace.ID

    var body: some View {
        let containerWidth = device == .pad ? size.width * 0.5 : size.width * 0.65
        let containerHeight = device == .pad ? size.height * 0.3 : size.height * 0.25

        let imageSize = device == .pad ? size.width * 0.3 : size.width * 0.3

        VStack(spacing: 5) {

            Image("appicon")
                .resizable()
                .cornerRadius(20)
                .padding(device == .pad ? 30 : 15)
                .frame(width: imageSize, height: imageSize)
            VStack(spacing: 5) {
                Text(verbatim: "Tria Tactics")
                    .font(device == .pad ? .largeTitle : .title)
                    .fontWeight(.bold)

                Text("The game for true tacticians!")
                    .font(device == .pad ? .title2 : .headline)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .onAppear {
            print(device)
        }
        .foregroundStyle(.textTheme)
        .padding()
        .background {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.buttonTheme.opacity(0.8))
                Button {
                    withAnimation {
                        view.value = .collaborators
                    }
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
        .frame(width: containerWidth, height: containerHeight)
    }

}

#Preview {
    TriaLogo(namespace: Namespace().wrappedValue)
}
