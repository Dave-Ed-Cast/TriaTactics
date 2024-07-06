//
    //  OnboardView.swift
    //  TicTacToe
    //
    //  Created by Davide Castaldi on 21/05/24.
    //

import SwiftUI

struct OnboardView: View {

    @ObservedObject var viewModel: OnboardingParameters
    @AppStorage("animationStatus") private var animationEnabled = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        TabView {
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.completed,
                onboardingTitle: "Welcome to Tria Tactics!",
                onboardingImage: "TicTacToe",
                onboardingText: "Tria Tactics is a revisited version of Tic Tac Toe. Play the classic game until something new will happen!",
                scaleFactor: 0.9
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.completed,
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "Making your fourth move of the game will cost the first one! And it keeps going after that! This is Tria Tactics...",
                scaleFactor: 1.1
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.completed,
                onboardingTitle: "Multiplayer is finally here!",
                onboardingImage: "Done",
                onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
                showDoneButton: true,
                scaleFactor: 0.9
            )
        }

        // this probably has to do with TabView component, but this needs a background otherwise it won't work
        .background {
            BackgroundView(savedValueForAnimation: $animationEnabled)
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

        .onDisappear {
            if viewModel.completed {
                viewModel.saveCompletionValue()
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
