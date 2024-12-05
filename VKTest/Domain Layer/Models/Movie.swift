import Foundation

struct Movie: Codable, Equatable, Identifiable {
    let id: Int
    var title: String
    var overview: String
    let posterPath: String?
    let voteAverage: Double?

    private enum CodingKeys: String, CodingKey {
        case id, title, overview, posterPath = "poster_path", voteAverage = "vote_average"
    }

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w500"
        return URL(string: baseURL + posterPath)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}




struct MovieResponse: Codable {
    let results: [Movie]
}

struct MovieImagesResponse: Codable {
    let backdrops: [Image]
}

struct Image: Codable {
    let filePath: String
}

struct MovieDetails: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
}
