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
    @State var isOffline: Bool = false
    @State private var showOnlineView: Bool = false
    @State private var showCreditsView: Bool = false
    
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    
    var body: some View {
        
        if !parameters.onboardingIsCompleted && !parameters.skipOnboarding {
            OnboardView(viewModel: parameters)
                .onDisappear {
                    if parameters.onboardingIsCompleted {
                        parameters.completeOnboarding()
                    }
                }
        } else {
            NavigationView {
                VStack(spacing: -150) {
                    Spacer()
                        viewManagerView
                }
            }
            .onAppear {
                matchManager.authenticateUser()
            }
            .tint(.black)
            .lineLimit(1)
        }
    }
    
    var mainMenuView: some View {
        VStack {
            Text("Tria Tactics")
                .font(.largeTitle)
                .fontWeight(.black)
            
            VStack(spacing: 190) {
                Text("The game for true tacticians!")
                    .font(.headline)
                
                VStack (spacing: 20) {
                    onlineButtonView
                    offlineButtonView
                    tutorialButtonView
                    creditsButtonView
                }
                
            }
        }
    }
    
    var viewManagerView: some View {
        Group {
            
            if matchManager.inGame && matchManager.autheticationState == .authenticated {
                GameView(matchManager: matchManager, gameLogic: gameLogic, isOffline: .constant(false))
            } else {
                mainMenuView
                Spacer()
                Text("Status: \(matchManager.autheticationState.rawValue)")
                    .font(.body)
                    .padding()
                    .onChange(of: matchManager.inGame) { _ in
                        showOnlineView = false
                    }
            }
            
        }
    }
    
    var onlineButtonView: some View {
        Button(action: {
            if !matchManager.inGame {
                matchManager.startMatchmaking()
            }
            showOnlineView = true
        }) {
            Text("Play Online")
                .fontWeight(.bold)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
                .foregroundStyle(.black)
                .font(.title)
        }
        .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
        .disabled(matchManager.autheticationState != .authenticated)
    }
    
    var offlineButtonView: some View {
        Button(action: {
            
        }) {
            NavigationLink(destination: GameView(matchManager: matchManager, isOffline: .constant(true))) {
                Text("Play Offline")
                    .fontWeight(.bold)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.yellow)
                    )
                    .foregroundStyle(.black)
                    .font(.title)
            }
        }
    }
    
    var tutorialButtonView: some View {
        Button {
            showTutorialView = true
        } label: {
            Text("Tutorial")
                .fontWeight(.medium)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
                .foregroundStyle(.black)
                .font(.title3)
        }
        .sheet(isPresented: $showTutorialView) {
            TutorialView()
        }
    }
    
    var creditsButtonView: some View {
        Button {
            showCreditsView = true
        } label: {
            Text("Credits")
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.yellow)
                )
                .foregroundStyle(.black)
                .font(.title3)
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
