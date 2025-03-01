import Foundation

// User model
struct User: Identifiable, Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let username: String
    let password: String
    let image: String
    
    // Make isFavorite an optional property with a default value
    var isFavorite: Bool
    
    // Custom coding keys to exclude isFavorite from decoding
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case username
        case password
        case image
    }
    
  
    init(id: Int, firstName: String, lastName: String, username: String, password: String, image: String, isFavorite: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.image = image
        self.isFavorite = isFavorite
    }
    
  
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        image = try container.decode(String.self, forKey: .image)
        isFavorite = false
    }
    
  
}


struct UserResponse: Codable {
    let users: [User]
}

