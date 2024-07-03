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
    @Namespace private var animationNamespace

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

                            Text("Tria Tactics")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("The game for true tacticians!")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.textTheme)
                        .padding()
                        .background {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.buttonTheme.opacity(0.8))
                                infoButton
                            }
                        }
                        .matchedGeometryEffect(id: "heroRectangle", in: animationNamespace)
                        .padding(.bottom, 100)

                        VStack(spacing: 30) {
                            PrimaryButton(label: "Play", action: {
                                withAnimation {
                                    changeViewTo.value = .play
                                }
                            })
                            PrimaryButton(label: "Tutorial", action: {
                                withAnimation {
                                    changeViewTo.value = .tutorial
                                }
                            })
                        }// end of 2nd inner vstack
                    }// end of outer vstack

                    .background {
                        BackgroundView()
                    }
                }
                .tint(.black)
                .lineLimit(1)
            }
        }
    }

    var infoButton: some View {
        Button {
            showCreditsView = true
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.buttonTheme)
                .font(.title3)
                .colorInvert()
        }
        .sheet(isPresented: $showCreditsView) {
            CreditsView()
        }
        .padding()
    }
}

#Preview {
    MainView()
        .environmentObject(MatchManager())
        .environmentObject(GameLogic())
        .environmentObject(Navigation.shared)
}
