//
//  ContentView.swift
//  TicTacToe
//
//  Created by Davide Castaldi on 17/05/24.
//

 import SwiftUI

 struct MainView: View {

    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var view: Navigation

    @AppStorage("animationStatus") private var animationEnabled = true

    @State private var isSettingsPresented = false
    @State private var isAnimationEnabled = UserDefaults.standard.bool(forKey: "animationStatus")

    var namespace: Namespace.ID

    let size = UIScreen.main.bounds

    var body: some View {

        ZStack {

            VStack(spacing: 10) {
                VStack {
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(height: size.height / 7.5)

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
                .matchedGeometryEffect(id: "icon", in: namespace)

                .padding(.bottom, 50)

                VStack(spacing: 30) {
                    PrimaryButton(label: "Play", action: {
                        withAnimation {
                            view.value = .play
                        }
                    }, color: .buttonTheme.opacity(0.8))

                    VStack(spacing: 10) {
                        SecondaryButton(label: "Tutorial", action: {
                            withAnimation {
                                view.value = .tutorial
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

            .lineLimit(1)
        }
        .halfModal(isPresented: $isSettingsPresented) {
            SettingsView(toggleAnimation: $isAnimationEnabled)
                .onDisappear {
                    isSettingsPresented = false
                }
        }
        .animation(.none, value: view.value)
    }

    var infoButton: some View {
        Button {
            withAnimation {
                view.value = .collaborators
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
    PreviewWrapper {
        MainView(namespace: Namespace().wrappedValue)
    }
 }
