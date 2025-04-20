import SwiftUI

struct AddFriendView: View {
    @State private var friendUsername: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a Friend")
                .font(.title2.bold())

            TextField("Enter username", text: $friendUsername)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Send Request") {
                // Add request logic here
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}
