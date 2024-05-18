//
//  LottieOnBoardingApp.swift
//  LottieOnBoarding
//
//  Created by Davide Castaldi on 27/04/24.
//

import SwiftUI

@main
struct LottieOnBoardingApp: App {

    //given the onboarding, we need it only once. So, we load the value when we launch the app
    var body: some Scene {
        WindowGroup {
            ContentView(onboardingIsOver: UserDefaults.standard.bool(forKey: "OnboardingStatus"))
        }
    }
}
