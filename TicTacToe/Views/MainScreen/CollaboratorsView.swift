//
//  CollaboratorsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import SwiftUI

struct CollaboratorsView: View {

    @EnvironmentObject var changeViewTo: Navigation
    @AppStorage("animationStatus") private var animationEnabled = true

    var collaborators: [Collaborator] = Collaborator.list

    var body: some View {

            VStack {
                ScrollView {
                ForEach(collaborators) { collab in
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(collab.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(collab.role)
                                .font(.headline)
                            Text(collab.contribute)
                                .font(.callout)
                        }
                        .foregroundStyle(.textTheme)
                        .padding()

                        Spacer()

                        Link(destination: URL(string: collab.contactInfo)!, label: {
                            Text("Their page")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .underline(true)
                        })
                        .padding()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.buttonTheme.opacity(0.8))
                    }
                    .lineLimit(nil)
                    .padding()

                }
            }

        }
        .overlay(alignment: .topTrailing) {
            TertiaryButton {
                withAnimation {
                    changeViewTo.value = .main
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
