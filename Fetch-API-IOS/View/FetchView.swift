

import SwiftUI

struct FetchView: View {
    @State private var users : [User] = []
    @State private var  errorMessage : String?
    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(users) { user in
                    Text("\(user.firstName) \(user.lastName)")
                }
            }
        }
        .onAppear{
            Task{
                do{
                    users = try await NetworkManager.shared.ApiFetch()
                }
                catch{
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    FetchView()
}
