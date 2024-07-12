//
//  PlayView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 20/06/24.
//

import SwiftUI

struct PlayView: View {

    @AppStorage("animationStatus") private var animationEnabled = true

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var changeViewTo: Navigation

    @Namespace private var namespace

    let size = UIScreen.main.bounds

    var body: some View {
        VStack {
            Spacer()
            // rectangle
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
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.buttonTheme.opacity(0.8))
            }
            .matchedGeometryEffect(id: "heroRectangle", in: namespace)
            .padding(.top, 100)

            Spacer()

            // buttons
            VStack(spacing: 20) {
                PrimaryButton(label: "Play Online", action: {
                    matchManager.startMatchmaking()
                }, color: .buttonTheme.opacity(0.8))
                .opacity(matchManager.authenticationState != .authenticated ? 0.5 : 1)
                .disabled(matchManager.authenticationState != .authenticated)

                PrimaryButton(label: "Play Offline", action: {
                    withAnimation {
                        changeViewTo.value = .offline
                    }
                }, color: .buttonTheme.opacity(0.8))
                PrimaryButton(label: "Play vs AI", action: {
                    withAnimation {
                        changeViewTo.value = .bot
                    }
                }, color: .buttonTheme.opacity(0.8))
            }
            .padding(.top, 50)

            Spacer()

            // menu
            SecondaryButton(label: "Menu", action: {
                withAnimation {
                    changeViewTo.value = .main
                }
            }, color: .buttonTheme.opacity(0.8))

        }

        .onAppear {
            matchManager.authenticateUser()
        }
    }
}

#Preview {
    PreviewWrapper {
        PlayView()
    }
}
