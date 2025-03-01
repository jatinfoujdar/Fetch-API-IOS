import SwiftUI

struct FetchView: View {
    @State private var users: [User] = []
    @State private var favoriteUsers: [User] = []
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    @State private var isSorted: Bool = false
    @State private var isOn: Bool = false
    
    
    var searchFilter: [User] {
        let baseUsers = isOn ? favoriteUsers : users
        return NetworkManager.searchfilter(users: baseUsers, searchText: searchText)
    }
    
    // Function to update favorite users array
    private func updateFavoriteUsers() {
        favoriteUsers = users.filter { $0.isFavorite }
    }
    
    var body: some View {
        VStack {
            HeaderView()
            TextField("Search", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle(isOn: $isOn) {
                Text("Show Favorites Only")
            }
            .padding()
            
            if users.isEmpty {
                ProgressView()
            }
            else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(searchFilter) { user in
                    HStack {
                        AsyncImage(url: URL(string: user.image)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } else if phase.error != nil {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        Text("\(user.firstName) \(user.lastName)")
                        Spacer()
                        Button(action: {
                            if let index = users.firstIndex(where: { $0.id == user.id }) {
                                users[index].isFavorite.toggle()
                                updateFavoriteUsers()
                            }
                        }) {
                            Image(systemName: user.isFavorite ? "star.fill" : "star")
                                .foregroundStyle(user.isFavorite ? .yellow : .gray)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    users = try await NetworkManager.shared.ApiFetch()
                    updateFavoriteUsers()  // Initial population of favorite users
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
        .onChange(of: isOn) { _ in
            updateFavoriteUsers()
        }
    }
}

#Preview {
    FetchView()
        .preferredColorScheme(.dark)
}
