import Foundation

struct SearchResponse: Decodable {
    let items: [Repository]
}

struct Repository: Decodable, Equatable {
    let name: String
    let description: String
    let owner: Owner

    static func ==(lhs: Repository, rhs: Repository) -> Bool {
        return lhs.name == rhs.name  
    }
}

struct Owner: Decodable {
    let avatar_url: String
}
