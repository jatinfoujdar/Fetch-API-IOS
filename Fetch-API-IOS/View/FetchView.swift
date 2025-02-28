

import SwiftUI

struct FetchView: View {
    @State private var users : [User] = []
    @State private var errorMessage : String?
    @State private var searchText : String = ""
    
    var searchFilter : [User]{
        NetworkManager.searchfilter(users: users, searchText: searchText)
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(searchFilter) { user in
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
