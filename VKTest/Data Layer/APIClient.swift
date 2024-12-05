import Foundation

protocol APIClientProtocol {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
    func fetchMovieImages(movieId: Int) async throws -> [Image]
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetails
}

class APIClient: APIClientProtocol {
    static var shared = APIClient()
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "089f590fb0bc1b2a5f0e5b3558bcd40f"
    private let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwODlmNTkwZmIwYmMxYjJhNWYwZTViMzU1OGJjZDQwZiIsIm5iZiI6MTczMzQxMjc3NS42NTkwMDAyLCJzdWIiOiI2NzUxYzdhNzM3ZjE4NTYyMDIwODc4NjciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.TJlkHeDMxR6jqvo9nXXVoNsV-rhyxVpuTemQ0R3enfU"

    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        
        print("Fetched movies: \(response.results)")
        
        return response.results
    }

    
    func fetchMovieImages(movieId: Int) async throws -> [Image] {
        let url = URL(string: "\(baseURL)/movie/\(movieId)/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(MovieImagesResponse.self, from: data)
        return response.backdrops
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetails {
        let url = URL(string: "\(baseURL)/movie/\(movieId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
        return movieDetails
    }
}
