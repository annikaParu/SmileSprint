//
//  JournalingView.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI
import NaturalLanguage

struct JournalingView: View {
    @State private var text = ""
    @State private var detectedEmotion = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Write about your day")
                .font(.title2.bold())

            TextEditor(text: $text)
                .frame(height: 200)
                .cornerRadius(12)
                .padding()
                .background(Color(.systemGray6))

            Button("Analyze Emotion") {
                detectedEmotion = analyzeSentiment(from: text)
            }

            if !detectedEmotion.isEmpty {
                Text("Detected Mood: \(detectedEmotion)")
                    .font(.headline)
                    .padding()
            }

            NavigationLink("Continue to Quotes") {
                QuoteSwipeView()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }

    func analyzeSentiment(from text: String) -> String {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex,
                                        unit: .paragraph,
                                        scheme: .sentimentScore)
        guard let score = sentiment?.rawValue, let value = Double(score) else {
            return "Neutral"
        }

        if value > 0.3 { return "Positive 😊" }
        else if value < -0.3 { return "Negative 😞" }
        else { return "Neutral 😐" }
    }
}
