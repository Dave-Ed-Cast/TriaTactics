//
//  OnboardingViewModel.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 30/05/24.
//

import SwiftUI
import Combine

class OnboardingParameters: ObservableObject {
    @Published var onboardingIsCompleted: Bool
    @Published var skipOnboarding: Bool
    @Published var currentStep: Int

    private let onboardingStatusKey = "OnboardingStatus"
    
    init() {
        self.onboardingIsCompleted = UserDefaults.standard.bool(forKey: onboardingStatusKey)
        self.skipOnboarding = false
        self.currentStep = 0
    }
    
    func completeOnboarding() {
        self.onboardingIsCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingStatusKey)
    }
    
    func skip() {
        self.skipOnboarding = true
    }
}
