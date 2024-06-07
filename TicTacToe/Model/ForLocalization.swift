//
//  ForLocalization.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import SwiftUI

struct ForLocalization: View {
    
    let collaboratorName: String = "Davide Castaldi"
    let collaboratorRole: String = "Creator, Developer, UX Designer"
    let collaboratorContribute: String = "contribute"
    let collaboratorContactInfo: String = "https://www.linkedin.com/in/davide-castaldi31/"
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(collaboratorName)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(collaboratorRole)
                    .font(.headline)
                Text(collaboratorContribute)
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

#Preview("Spanish") {
    ForLocalization()
        .environment(\.locale, Locale(identifier: "SP"))
}

#Preview("EN") {
    ForLocalization()
        .environment(\.locale, Locale(identifier: "EN"))
}
