//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var parameters = OnboardingParameters()
    @EnvironmentObject var changeViewTo: Navigation

    @State private var showCreditsView: Bool = false

    var body: some View {

        ZStack {

            if !parameters.onboardingIsCompleted && !parameters.skipOnboarding {
                OnboardView(viewModel: parameters)
                    .onDisappear {
                        if parameters.onboardingIsCompleted {
                            parameters.completeOnboarding()
                        }
                    }
            } else {
                NavigationView {
                    VStack(spacing: 10) {
                        VStack {
                            Image("appicon")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 120)
                                .cornerRadius(20)
                                .padding()
                            Text("Tria Tactics")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("The game for true tacticians!")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.black)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.6))
                        }
                        .padding(.bottom, 100)

                        VStack(spacing: 20) {

                            PrimaryButton(label: "Play", action: { changeViewTo.value = .play })
                            PrimaryButton(label: "Tutorial", action: { changeViewTo.value = .tutorial })
                        }// end of 2nd inner vstack
                    }// end of outer vstack
                    .toolbar {
                        Button {
                            showCreditsView = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                        .sheet(isPresented: $showCreditsView) {
                            CreditsView()
                        }
                    }
                    .background {
                        BackgroundView()
                    }
                }
                .tint(.black)
                .lineLimit(1)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject(Navigation.shared)
}
