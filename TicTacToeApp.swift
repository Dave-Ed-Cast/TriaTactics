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
    @StateObject private var matchManager = MatchManager.shared
    @StateObject private var gameLogic = GameLogic.shared
    @StateObject private var navigation = Navigation.shared

    @AppStorage("animationStatus") private var animationEnabled = true

    @Environment(\.colorScheme) var colorScheme

    init() {
        if UserDefaults.standard.object(forKey: "hasLaunchedBefore") == nil {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "animationStatus")
        }
        GameLogic.shared.matchManager = MatchManager.shared
        MatchManager.shared.gameLogic = GameLogic.shared
    }

    var body: some Scene {

        WindowGroup {
            if onboarding.completed || onboarding.skipped {
                ParentView()
                    .environmentObject(matchManager)
                    .environmentObject(gameLogic)
                    .environmentObject(navigation)
            } else {
                OnboardView(onboarding: onboarding)
            }
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

struct CustomPushTransitionModifier: ViewModifier {
    let isActive: Bool
    let direction: Edge

    func body(content: Content) -> some View {
        content
            .offset(x: isActive ? 0 : direction == .leading ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width, y: 0)
            .opacity(isActive ? 1 : 0)
            .animation(.easeInOut, value: isActive)
    }
}

extension AnyTransition {
    static func customPush(cfrom edge: Edge) -> AnyTransition {
        if #available(iOS 16.0, *) {
            return .push(from: edge)
        } else {
            return .modifier(
                active: CustomPushTransitionModifier(isActive: true, direction: edge),
                identity: CustomPushTransitionModifier(isActive: false, direction: edge)
            )
        }
    }
}
