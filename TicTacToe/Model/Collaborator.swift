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
            contactInfo: "https://www.linkedin.com/in/davide-castaldi31/"
        ),
        
        Collaborator(
            name: "Sabrina Silvestri",
            role: "UI/UX Designer",
            contribute: "App icon",
            contactInfo: "https://www.linkedin.com/in/sabrinasilvestri/"
        ),
        
        Collaborator(
            name: "Mahary Esposito",
            role: "UI/UX Designer",
            contribute: "Assets",
            contactInfo: "https://www.linkedin.com/in/maharyesposito/"
        ),
        
//        Collaborator(
//            name: "Giuseppe Francione",
//            role: "Developer",
//            contribute: "Code refactoring",
//            contactInfo: "https://www.linkedin.com/in/giuseppe-francione-69008125a/"
//        ),
        
        Collaborator(
            name: "Fernanda Lozoya Navarro",
            role: "UI/UX Designer",
            contribute: "Localization",
            contactInfo: "placeholder"
        ),
        
        Collaborator(
            name: "",
            role: "",
            contribute: "",
            contactInfo: ""
        ),
        
        
    ]
}
