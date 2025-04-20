import SwiftUI

struct FriendFeedView: View {
    var mockFriends: [(name: String, mood: String)] = [
        ("Alex", "😊"), ("Jamie", "😢"), ("Taylor", "😐"), ("Jordan", "😄")
    ]

    var body: some View {
        NavigationView {
            List(mockFriends, id: \.name) { friend in
                HStack {
                    Text(friend.name)
                        .font(.headline)
                    Spacer()
                    Text(friend.mood)
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Friends' Moods")
        }
    }
}
