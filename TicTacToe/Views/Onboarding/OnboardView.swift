//
    //  OnboardView.swift
    //  TicTacToe
    //
    //  Created by Davide Castaldi on 21/05/24.
    //

import SwiftUI

struct OnboardView: View {

    @ObservedObject var viewModel: OnboardingParameters
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Welcome to Tria Tactics!",
                onboardingImage: "TicTacToe",
                onboardingText: "Tria Tactics is a revisited version of Tic Tac Toe. Play the classic game until something new will happen!",
                scaleFactor: 0.9
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "Making your fourth move of the game will cost the first one! And it keeps going after that! This is Tria Tactics...",
                scaleFactor: 1.1
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Multiplayer is finally here!",
                onboardingImage: "Done",
                onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
                showDoneButton: true,
                scaleFactor: 0.9
            )
        }

        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation {
                    viewModel.skip()
                }
            } label: {
                Text("Skip")
                    .padding()

            }
            .buttonBorderShape(.automatic)
            .padding()
        })
        .background {
            BackgroundView()
        }
        .onDisappear {
            if viewModel.onboardingIsCompleted {
                viewModel.completeOnboarding()
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardView(viewModel: OnboardingParameters())
            .environment(\.locale, Locale(identifier: "en"))

            OnboardView(viewModel: OnboardingParameters())
                .environment(\.locale, Locale(identifier: "it"))
        }
    }
}
