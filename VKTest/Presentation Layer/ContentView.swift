// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    @State private var errorMessage: String? = nil

    var apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(movies, id: \.id) { movie in
                    MovieCell(movie: movie)
                        .onAppear {
                            if movie == movies.last && !isLoading {
                                loadMoreData()
                            }
                        }
                        .swipeActions {
                            Button("Delete") {
                                deleteMovie(movie)
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("Movies")
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .onAppear {
                loadMoreData()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())  // если iPad
    }

    func loadMoreData() {
        isLoading = true
        Task {
            do {
                let newMovies = try await apiClient.fetchPopularMovies(page: currentPage)
                movies.append(contentsOf: newMovies)
                currentPage += 1
            } catch {
                errorMessage = "Failed to load data"
            }
            isLoading = false
        }
    }

    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
    }

    // тесты
    func getMovies() -> [Movie] {
        return movies
    }
    
    func getErrorMessage() -> String? {
        return errorMessage
    }
    
    func getIsLoading() -> Bool {
        return isLoading
    }
}

#Preview {
    ContentView()
}
