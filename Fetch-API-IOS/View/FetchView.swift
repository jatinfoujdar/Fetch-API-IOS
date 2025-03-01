import SwiftUI

struct FetchView: View {
    @State private var users : [User] = []
    @State private var errorMessage : String?
    @State private var searchText : String = ""
    @State private var isSorted: Bool = false
    @State private var showFavoritesOnly: Bool = false 
    
    var searchFilter : [User]{
        NetworkManager.searchfilter(users: users, searchText: searchText)
    }
    
    var body: some View {
        VStack {
            HeaderView()
            TextField("Search", text: $searchText)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if users.isEmpty{
                ProgressView()
            }
            
            else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
              
                List(searchFilter) { user in
                    HStack{
                        AsyncImage(url: URL(string: user.image)){phase in
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
                            }
                        }) {
                            Image(systemName: user.isFavorite ? "star.fill" : "star")
                                .foregroundStyle(user.isFavorite ? .yellow : .gray)
                        }
                    }
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
        .preferredColorScheme(.dark)
}
