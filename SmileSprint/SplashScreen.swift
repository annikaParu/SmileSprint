//
//  SplashScreen.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showWelcome = false
    @State private var fadeIn = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .mint],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "bolt.heart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .opacity(fadeIn ? 1 : 0)
                    .scaleEffect(fadeIn ? 1 : 0.6)
                    .animation(.easeOut(duration: 1.2), value: fadeIn)

                Text("SmileSprint")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut.delay(0.3), value: fadeIn)
            }
        }
        .onAppear {
            fadeIn = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showWelcome = true
            }
        }
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomeScreen()
        }
    }
}
