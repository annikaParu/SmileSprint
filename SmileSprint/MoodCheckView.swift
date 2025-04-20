//
//  MoodCheckView.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI

struct MoodCheckView: View {
    @State private var moodValue: Double = 3.0

    var body: some View {
        VStack(spacing: 30) {
            Text("How are you feeling?")
                .font(.title2.bold())

            Slider(value: $moodValue, in: 1...5, step: 1)
                .accentColor(.pink)
                .padding()

            Text(emoji(for: moodValue))
                .font(.system(size: 64))

            NavigationLink("Next") {
                ThoughtBubblesView()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }

    func emoji(for value: Double) -> String {
        switch Int(value) {
            case 1: return "😭"
            case 2: return "😢"
            case 3: return "😐"
            case 4: return "🙂"
            case 5: return "😄"
            default: return "😐"
        }
    }
}
