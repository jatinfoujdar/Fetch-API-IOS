import SwiftUI

struct HeaderView: View {
    @State private var users: [User] = []
    @State private var isSorted: Bool = false
    
    var body: some View {
        HStack{
            Image(systemName: "line.horizontal.3")
            .padding(.leading, 10)
            .onAppear{
                if isSorted {
                    users = NetworkManager.alphabetOrder(users: users)
                } else {
                    users = NetworkManager.alphabetOrder(users: users).reversed()
                }
                isSorted.toggle()
            }
            Spacer()
            Text("Contacts")
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .onAppear{
            Task{
                do{
                    users = try await NetworkManager.shared.ApiFetch()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    HeaderView()
}
