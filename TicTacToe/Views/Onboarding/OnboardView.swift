//
//  OnboardView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 21/05/24.
//

import SwiftUI

struct OnboardView: View {
    
    @ObservedObject var viewModel: OnboardingParameters
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Welcome to Tria Tactics!",
                onboardingImage: "TicTacToe",
                onboardingText: "Tria Tactics is a revisited version of Tic Tac Toe. Play the classic game until something new will happen!"
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Tria Tactics rule",
                onboardingImage: "Rule",
                onboardingText: "Making your fourth move of the game will make the first one disappear! And it keeps going after that! This is Tria Tactics..."
            )
            OnboardingPageViewModel(
                onboardingIsCompleted: $viewModel.onboardingIsCompleted,
                onboardingTitle: "Multiplayer is finally here!",
                onboardingImage: "Cool",
                onboardingText: "Here comes the multiplayer! Challenge your friends in a strategic battle. Log into Game Center and enjoy!",
                showDoneButton: true
            )
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation {
                    viewModel.skip()
                }
            } label: {
                Text("Skip")
            }
            .buttonBorderShape(.automatic)
            .padding()
        })
        .tabViewStyle(.page(indexDisplayMode: .automatic))
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
