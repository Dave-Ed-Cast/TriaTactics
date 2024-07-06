//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

enum NavigationValue {
    case main
    case play
    case online
    case offline
    case bot
    case tutorial
    case collaborators
}

class Navigation: ObservableObject {
    static var shared = Navigation()
    @Published public var value: NavigationValue = .main
    private init() {}
}

@main
struct TicTacToeApp: App {

    @StateObject private var onboarding = OnboardingParameters()
    @StateObject private var matchManager = MatchManager()
    @StateObject private var gameLogic = GameLogic()
    @StateObject private var navigation = Navigation.shared

//    @State private var animationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")
    @AppStorage("animationStatus") private var animationEnabled = true
//    @AppStorage("animationStatus") private var animationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    @Environment(\.colorScheme) var colorScheme

    init() {
        if UserDefaults.standard.object(forKey: "hasLaunchedBefore") == nil {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "animationStatus")
        }
    }

    var body: some Scene {

        WindowGroup {
            Group {
                if onboarding.completed || onboarding.skipped {
                    ParentView()
                } else {
                    OnboardView(viewModel: onboarding)
                }
            }
            .environmentObject(matchManager)
            .environmentObject(gameLogic)
            .environmentObject(navigation)
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func halfModal<ModalContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ModalContent) -> some View {
        self.modifier(HalfModalView(isPresented: isPresented, modalContent: content))
    }
}
