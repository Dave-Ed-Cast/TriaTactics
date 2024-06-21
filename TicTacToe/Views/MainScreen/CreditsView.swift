//
//  CreditsView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import SwiftUI

struct CreditsView: View {

    var collaborator: [Collaborator] = Collaborator.list
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Group {
            ForEach(collaborator) { collab in
                HStack {
                    VStack(alignment: .leading) {
                        Text(collab.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(collab.role)
                            .font(.headline)
                        Text(collab.contribute)
                            .font(.callout)
                    }
                    .padding()

                    Spacer()

                    Link(destination: URL(string: collab.contactInfo)!, label: {
                        Text("Their page")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .underline(true)
                    })
                    .padding()
                }
                .background(.yellow)
                .lineLimit(nil)
                .padding()

            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }

                }
            })
        }

    }

}

#Preview("English") {

    CreditsView()
        .environment(\.locale, Locale(identifier: "EN"))

}
