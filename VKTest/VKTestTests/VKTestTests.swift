import XCTest
@testable import VKTest

final class VKTestTests: XCTestCase {
    
    // Мок API
    class MockAPIClient: APIClientProtocol {
        var shouldReturnError = false
        
        func fetchPopularMovies(page: Int) async throws -> [Movie] {
            if shouldReturnError {
                throw NSError(domain: "TestError", code: 1, userInfo: nil)
            }
            return [
                Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "url1", voteAverage: 8.0),
                Movie(id: 2, title: "Movie 2", overview: "Overview 2", posterPath: "url2", voteAverage: 7.5)
            ]
        }
        
        func fetchMovieImages(movieId: Int) async throws -> [Image] {
            return []
        }
        
        func fetchMovieDetails(movieId: Int) async throws -> MovieDetails {
            return MovieDetails(id: movieId, title: "Dummy", overview: "Dummy Overview", releaseDate: "2024-01-01")
        }
    }
    
    var contentView: ContentView!
    var mockAPIClient: MockAPIClient!
    
    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        contentView = ContentView(apiClient: mockAPIClient)
    }

    override func tearDownWithError() throws {
        contentView = nil
        mockAPIClient = nil
    }

    func testLoadMoviesSuccessfully() async throws {
        mockAPIClient.shouldReturnError = false
        await contentView.loadMoreData()
        
        // проверка, что данные загружены
        XCTAssertEqual(contentView.getMovies().count, 2)
        XCTAssertEqual(contentView.getMovies().first?.title, "Movie 1")
    }
    
    func testLoadMoviesWithError() async throws {
        mockAPIClient.shouldReturnError = true
        await contentView.loadMoreData()
        
        // проверка, что состояние ошибки обновлено
        XCTAssertEqual(contentView.getMovies().count, 0)
        XCTAssertNotNil(contentView.getErrorMessage())
    }
    
    func testLoadingState() async throws {
        mockAPIClient.shouldReturnError = false
        let expectation = XCTestExpectation(description: "Loading State")
        
        Task {
            await contentView.loadMoreData()
            XCTAssertTrue(contentView.getIsLoading())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPerformanceExample() throws {
        self.measure {
            Task {
                _ = try? await mockAPIClient.fetchPopularMovies(page: 1)
            }
        }
    }
}
