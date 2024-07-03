//
//  PlayView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PlayView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var changeViewTo: Navigation

    @State private var isOffline: Bool = false
    @State private var showGameView: Bool = false
    @State private var showCreditsView: Bool = false
    @Namespace private var animationNamespace

    var body: some View {
        VStack {
            Spacer()
            // rectangle
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
            .foregroundStyle(.black)
            .padding()
            .background {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.8))
                    infoButton
                }
            }
            .matchedGeometryEffect(id: "heroRectangle", in: animationNamespace)
            .padding(.top, 100)

            Spacer()

            // buttons
            VStack(spacing: 15) {
                PrimaryButton(label: "Play Online", action: {
                    matchManager.startMatchmaking()
                    if matchManager.inGame && matchManager.autheticationState == .authenticated {
                        withAnimation {
                            changeViewTo.value = .online
                        }
                    }
                })
                .opacity(matchManager.autheticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.autheticationState != .authenticated)

                PrimaryButton(label: "Play Offline", action: {
                    withAnimation {
                        changeViewTo.value = .offline
                    }
                })
                PrimaryButton(label: "Play vs AI", action: {
                    withAnimation {
                        changeViewTo.value = .offline
                    }
                })
            }
            .padding(.top, 50)

            Spacer()

            // menu
            SecondaryButton(label: "Menu", action: {
                withAnimation {
                    changeViewTo.value = .main
                }
            })
        }
        .background {
            BackgroundView()
        }
        .onAppear {
            matchManager.authenticateUser()
        }
    }

    var infoButton: some View {
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
        .padding()
    }
}

#Preview {
    PlayView()
        .environmentObject(MatchManager())
        .environmentObject(Navigation.shared)
}
