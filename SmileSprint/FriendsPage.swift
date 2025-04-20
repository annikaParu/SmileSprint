//
//  FriendsPage.swift
//  SmileSprint
//
//  Created by Gaurav Jena on 4/19/25.
//


//  SmileSprint

import SwiftUI

struct FriendsPage: View {
    var body: some View {
        TabView {
            FriendsTab()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }

            QuoteSwipeView()
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quotes")
                }
        }
    }
}

struct FriendsTab: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("See how your friends are feeling today")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add friend action here
                    }) {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
        }
    }
}
