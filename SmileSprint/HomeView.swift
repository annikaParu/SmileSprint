// HomeView.swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            FriendFeedView()
                .tabItem {
                    Label("Friends", systemImage: "person.3.fill")
                }

            QuoteStoriesView()
                .tabItem {
                    Label("Quotes", systemImage: "quote.bubble.fill")
                }

            AddFriendView()
                .tabItem {
                    Label("Add", systemImage: "person.badge.plus.fill")
                }
        }
    }
}
