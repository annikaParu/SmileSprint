//
//  ThoughtBubblesView.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//

import SwiftUI

struct ThoughtBubble: Identifiable {
    let id = UUID()
    let word: String
    let isPositive: Bool
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let moodEmoji: String
}

struct ThoughtBubblesView: View {
    @EnvironmentObject private var model: EmotionalModel
    @AppStorage("moodValue") private var moodValue: Double = 3.0
    @State private var bubbles: [ThoughtBubble] = []
    @State private var kept: [ThoughtBubble] = []
    @State private var released: [ThoughtBubble] = []
    @State private var navigateToHome = false

    // MARK: - Emotion Lists

    private let positiveEmotions: [(String, Bool)] = [
        ("Hope", true), ("Gratitude", true), ("Joy", true), ("Calm", true),
        ("Confident", true), ("Self-Love", true), ("Resilience", true), ("Patience", true),
        ("Pride", true), ("Optimism", true), ("Kindness", true), ("Motivation", true),
        ("Peace", true), ("Empathy", true), ("Excitement", true), ("Cheerfulness", true),
        ("Courage", true), ("Serenity", true), ("Satisfaction", true), ("Inspiration", true)
    ]

    private let negativeEmotions: [(String, Bool)] = [
        ("Worry", false), ("Stress", false), ("Fear", false), ("Doubt", false),
        ("Guilt", false), ("Frustration", false), ("Loneliness", false), ("Anxious", false),
        ("Shame", false), ("Anger", false), ("Overthinking", false), ("Sadness", false),
        ("Jealousy", false), ("Embarrassment", false), ("Disappointment", false), ("Regret", false),
        ("Irritation", false), ("Hopelessness", false), ("Envy", false), ("Tiredness", false)
    ]

    private let sampleFriends: [Friend] = [
        Friend(name: "Alex", moodEmoji: "😊"),
        Friend(name: "Jamie", moodEmoji: "😭"),
        Friend(name: "Taylor", moodEmoji: "😐"),
        Friend(name: "Jordan", moodEmoji: "😄"),
        Friend(name: "Avery", moodEmoji: "🙂"),
        Friend(name: "Sam", moodEmoji: "🙃")
    ]

    var body: some View {
        TabView {
            NavigationView {
                List(sampleFriends) { friend in
                    HStack {
                        Text(friend.name)
                        Spacer()
                        Text(friend.moodEmoji)
                    }
                }
                .navigationTitle("Friends")
                .navigationBarItems(trailing:
                    Button(action: {
                        // Add friend action
                    }) {
                        Image(systemName: "person.badge.plus")
                    }
                )
            }
            .tabItem {
                Label("Friends", systemImage: "person.2.fill")
            }

            NavigationView {
                ZStack {
                    LinearGradient(colors: [.purple, .pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()

                    QuoteSwipeView()
                }
            }
            .tabItem {
                Label("Quotes", systemImage: "quote.bubble")
            }

            NavigationView {
                ZStack {
                    LinearGradient(colors: [.cyan.opacity(0.4), .mint.opacity(0.5)],
                                   startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Text("Tap to keep or release thoughts")
                            .font(.headline)
                            .padding()

                        GeometryReader { geo in
                            let cols = 4
                            let spacing: CGFloat = 10
                            let bubbleSize: CGFloat = (geo.size.width - CGFloat(cols + 1) * spacing) / CGFloat(cols)

                            LazyVGrid(columns: Array(repeating: GridItem(.fixed(bubbleSize), spacing: spacing), count: cols), spacing: spacing) {
                                ForEach(bubbles) { bubble in
                                    if bubble.isPositive || !released.contains(where: { $0.id == bubble.id }) {
                                        Text(bubble.word)
                                            .font(.headline)
                                            .frame(width: bubbleSize, height: bubbleSize)
                                            .background(bubble.isPositive ? Color.green.opacity(0.7) : Color.red.opacity(0.6))
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                handleTap(bubble)
                                            }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxHeight: .infinity)

                        if released.count == bubbles.filter { !$0.isPositive }.count {
                            NavigationLink(
                                destination: EmptyView(),
                                isActive: $navigateToHome
                            ) {
                                EmptyView()
                            }
                            .hidden()

                            Button("Reflect & Continue") {
                                navigateToHome = true
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Spacer()
                    }
                }
            }
            .tabItem {
                Label("Thoughts", systemImage: "bubble.left.and.bubble.right.fill")
            }
        }
        .onAppear {
            generateBubbles()
        }
    }

    // MARK: - Logic

    func generateBubbles() {
        let mood = Int(moodValue)
        let positiveCount: Int

        switch mood {
        case 1: positiveCount = 0
        case 2: positiveCount = 5
        case 3: positiveCount = 10
        case 4: positiveCount = 15
        case 5: positiveCount = 20
        default: positiveCount = 10
        }

        let negativeCount = 20 - positiveCount
        let selectedPositives = positiveEmotions.shuffled().prefix(positiveCount)
        let selectedNegatives = negativeEmotions.shuffled().prefix(negativeCount)

        let selected = (selectedPositives + selectedNegatives).shuffled()

        bubbles = selected.map { word, isPositive in
            ThoughtBubble(word: word, isPositive: isPositive)
        }
    }

    func handleTap(_ bubble: ThoughtBubble) {
        if bubble.isPositive {
            // Do not remove green bubbles
            return
        } else {
            released.append(bubble)
            bubbles.removeAll { $0.id == bubble.id }
        }
    }
}
