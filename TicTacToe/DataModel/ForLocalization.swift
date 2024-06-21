//
//  ForLocalization.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import SwiftUI

struct ForLocalization: View {

    let collaboratorName: String = "Ciro Esposito"
    let collaboratorRole: LocalizedStringKey = "Creator, Developer, UX Designer"
    let collaboratorContribute: LocalizedStringKey = "App icon"
    let collaboratorContribute2: LocalizedStringKey = "Assets"
    let collaboratorContactInfo: String = "https://www.linkedin.com/in/davide-castaldi31/"

    var body: some View {

        HStack {
            VStack(alignment: .leading) {
                Text(collaboratorName)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(collaboratorRole)
                    .font(.headline)
                HStack {
                    Text(collaboratorContribute)
                    Text(collaboratorContribute2)
                }
                .font(.callout)
            }
            .padding()

            Spacer()

            Link(destination: URL(string: collaboratorContactInfo)!, label: {
                Text("Their page")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .underline(true)
            })
            .padding()
        }
        .background(.yellow)
    }
}

#Preview("English") {
    ForLocalization()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian") {
    ForLocalization()
        .environment(\.locale, Locale(identifier: "IT"))
}

#Preview("Mexican") {
    ForLocalization()
        .environment(\.locale, Locale(identifier: "ES"))
}
