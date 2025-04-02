//
//  OnboardingViewModel.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 30/05/24.
//

import SwiftUI

class OnboardingParameters: ObservableObject {
    @Published var completed: Bool
    @Published var skipped: Bool
    @Published var currentStep: Int

    private let onboardingStatusKey = "OnboardingStatus"

    init() {
        self.completed = UserDefaults.standard.bool(forKey: onboardingStatusKey)
        self.skipped = false
        self.currentStep = 0
    }

    func saveCompletionValue() {
        self.completed = true
        UserDefaults.standard.set(true, forKey: onboardingStatusKey)
    }

    func skip() {
        self.skipped = true
    }
}
