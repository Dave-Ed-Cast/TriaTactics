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
    @EnvironmentObject var animationSettings: AnimationSettings

    @State private var showCreditsView: Bool = false
    @State private var isSettingsPresented = false
    @State private var isAnimationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    @Namespace private var namespace

    let size = UIScreen.main.bounds

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

                VStack(spacing: 10) {
                    VStack {
                        Image("appicon")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .matchedGeometryEffect(id: "icon", in: namespace)
                            .frame(height: size.height / 7.5)

                        Text("Tria Tactics")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "title", in: namespace)
                        Text("The game for true tacticians!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .matchedGeometryEffect(id: "subtitle", in: namespace)
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

                    .padding(.bottom, 100)

                    VStack(spacing: 30) {
                        PrimaryButton(label: "Play", action: {
                            withAnimation {
                                changeViewTo.value = .play
                            }
                        }, color: .buttonTheme.opacity(0.8))

                        VStack(spacing: 10) {
                            SecondaryButton(label: "Tutorial", action: {
                                withAnimation {
                                    changeViewTo.value = .tutorial
                                }
                            }, color: .buttonTheme.opacity(0.8))

                            SecondaryButton(label: "Settings", action: {
                                withAnimation {
                                    isSettingsPresented.toggle()
                                }
                            }, color: .buttonTheme.opacity(0.8))
                        }
                    }// end of 2nd inner vstack

                }// end of outer vstack

                .background {
                    BackgroundView()
                }
                .lineLimit(1)
            }
        }
        .halfModal(isPresented: $isSettingsPresented) {
            SettingsView(isAnimationEnabled: $isAnimationEnabled)
                .onDisappear {
                    isSettingsPresented = false
                }
        }
    }

    var infoButton: some View {
        Button {
            withAnimation {
                changeViewTo.value = .collaborators
            }
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(.buttonTheme)
                .font(.title3)
                .colorInvert()
        }
        .padding()
    }
}

#Preview {
    MainView()
        .environmentObject(MatchManager())
        .environmentObject(Navigation.shared)
        .environmentObject(AnimationSettings(isAnimationEnabled: .constant(true)))
}
