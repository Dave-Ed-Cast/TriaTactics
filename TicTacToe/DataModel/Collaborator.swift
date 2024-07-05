//
//  Creators.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 04/06/24.
//

import Foundation
import SwiftUI

struct Collaborator: Identifiable {

    var id: UUID = UUID()
    var name: String = ""
    var role: LocalizedStringKey = ""
    var contribute: LocalizedStringKey = ""
    var contactInfo: String = ""

    static let list = [
        Collaborator(
            name: "Davide Castaldi",
            role: "Creator, Developer, UX Designer",
            contribute: "Game logic, Online logic, Development and design",
            contactInfo: "https://www.linkedin.com/in/davide-castaldi31/"
        ),

        Collaborator(
            name: "Sabrina Silvestri",
            role: "UI/UX Designer",
            contribute: "App icon, UX design",
            contactInfo: "https://www.linkedin.com/in/sabrinasilvestri/"
        ),

        Collaborator(
            name: "Mahary Esposito",
            role: "UI/UX Designer",
            contribute: "Assets, UI/UX design",
            contactInfo: "https://www.linkedin.com/in/maharyesposito/"
        ),

        Collaborator(
            name: "Giuseppe Francione",
            role: "Developer",
            contribute: "Code refactoring, navigation system, background animation skeleton",
            contactInfo: "https://www.linkedin.com/in/giuseppe-francione-69008125a/"
        )
    ]
}
