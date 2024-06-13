import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var movieSearch: MovieSearch? = nil
    
    var networkService: NetworkService?
    
    init(networkService: NetworkService? = nil) {
        self.networkService = networkService
    }
    
    func searchMovies() {
           guard let networkService = networkService,
                 let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(searchText)") else { return }
           
           isLoading = true
           
        Task {
                do {
                    let movies = try await networkService.fetchDataWithRetry(from: url, retries: 3, delay: 2)
                    await MainActor.run {
                        self.movieSearch = movies
                        self.isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        self.isLoading = false
                        print("Failed to fetch data after retries: \(error)")
                    }
                }
            }
        }
       
       func constructPosterURL(posterPath: String, size: String = "w185") -> URL? {
           let baseURL = "https://image.tmdb.org/t/p/"
           let fullPath = baseURL + size + posterPath
           return URL(string: fullPath)
       }
}
