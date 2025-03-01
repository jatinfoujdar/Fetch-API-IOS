import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let apiUrl = "https://dummyjson.com/users"
    
    private init() {}
    
    // Fetch API data and decode into [User] array
    func ApiFetch() async throws -> [User] {
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        // Debug: Print the raw JSON response
        if let jsondata = String(data: data, encoding: .utf8) {
            print(jsondata)
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        do {
            // Decode the API response to the UserResponse model
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            return userResponse.users
        } catch {
            throw error
        }
    }
    
    // Search filter function
    static func searchfilter(users: [User], searchText: String) -> [User] {
        guard !searchText.isEmpty else {
            return alphabetOrder(users: users)
        }
        
        return users.filter { user in
            user.firstName.lowercased().contains(searchText.lowercased()) ||
            user.lastName.lowercased().contains(searchText.lowercased()) ||
            user.username.lowercased().contains(searchText.lowercased())
        }
    }
    
    // Alphabetical order function
    static func alphabetOrder(users: [User]) -> [User] {
        guard !users.isEmpty else { return users }
        
        return users.sorted {
            $0.firstName.lowercased() < $1.firstName.lowercased()
        }
    }
}
