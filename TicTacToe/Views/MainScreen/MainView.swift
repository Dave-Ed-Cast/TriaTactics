//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var parameters = OnboardingParameters()

    @State private var showTutorialView: Bool = false
    @State private var showCreditsView: Bool = false
    @State private var showPlayView: Bool = false
    @EnvironmentObject var changeViewTo: Navigation
    var body: some View {

//        if !parameters.onboardingIsCompleted && !parameters.skipOnboarding {
//            OnboardView(viewModel: parameters)
//                .onDisappear {
//                    if parameters.onboardingIsCompleted {
//                        parameters.completeOnboarding()
//                    }
//                }
//        } else {
            NavigationView {
                VStack(spacing: 10) {
                    VStack {
                        Text("Tria Tactics")
                            .font(.largeTitle)
                            .fontWeight(.black)

                        Text("The game for true tacticians!")
                            .font(.headline)
                    }// end of 1st inner vstack
                    .padding(.bottom, 200)

                    VStack(spacing: 20) {

                        PrimaryButton(showSomething: $showPlayView, buttonText: "Play", action: {
                            changeViewTo.value = .play
                            })

                        SecondaryButton(showSomething: $showTutorialView, buttonText: "Tutorial", action: {
                            changeViewTo.value = .tutorial
                        })
                    }// end of 2nd innervstack
                }// end of outer vstack
                .toolbar {
                    creditsButtonView
                }
            }
            .tint(.black)
            .lineLimit(1)
        }
//    }

    var creditsButtonView: some View {
        Button {
            showCreditsView = true
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.black)
                .font(.title3)
                .padding()
        }
        .sheet(isPresented: $showCreditsView) {
            CreditsView()
        }
    }

}

#Preview {
    MainView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
}
