//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(onboardingIsOver: UserDefaults.standard.bool(forKey: "OnboardingStatus"), currentStep: .constant(0))
                .preferredColorScheme(.light)
        }
    }
}
