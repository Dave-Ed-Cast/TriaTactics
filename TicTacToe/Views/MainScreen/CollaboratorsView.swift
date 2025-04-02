//
//  CollaboratorsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import SwiftUI

struct CollaboratorsView: View {

    @EnvironmentObject var view: Navigation
    @AppStorage("animationStatus") private var animationEnabled = true

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.device) private var device

    var collaborators: [Collaborator] = Collaborator.list

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            ScrollView {
                Spacer()
                VStack(spacing: 20) {
                    ForEach(collaborators) { collab in
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(collab.name)
                                    .font(device == .pad ? .largeTitle : .title2)
                                    .fontWeight(.bold)
                                Text(collab.role)
                                    .font(device == .pad ? .title : .headline)
                                Text(collab.contribute)
                                    .font(device == .pad ? .title3 : .callout)
                            }
                            .foregroundStyle(.textTheme)

                            Spacer()

                            Link(destination: URL(string: collab.contactInfo)!, label: {
                                Text("Their page")
                                    .font(device == .pad ? .callout : .subheadline)
                                    .fontWeight(.semibold)
                                    .underline(true)
                                    .foregroundStyle(.blue)
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.05) : .clear)
                                    }
                            })
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.buttonTheme.opacity(0.8))
                        }
                    }
                }
                .padding()
                .frame(width: size.width)
            }

            .overlay(alignment: .topTrailing) {
                HStack {
                    Spacer()
                    TertiaryButton {
                        withAnimation {
                            view.value = .main
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview("English") {

    PreviewWrapper {
        CollaboratorsView()
            .environment(\.locale, Locale(identifier: "EN"))
    }

}

#Preview {
    ParentView()
        .environmentObject(Navigation.shared)
        .environmentObject(MatchManager.shared)
        .environmentObject(GameLogic.shared)
}
