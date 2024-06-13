import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var movieSearch: MovieSearch? = nil
    
    var networkService: NetworkService?
    var urlString:String?
    
    init(networkService: NetworkService? = nil, urlString:String? = nil) {
        self.networkService = networkService
        self.urlString = urlString
    }
    
    func searchMovies() {
        guard let urlString = urlString, let networkService = networkService, let url = URL(string: urlString + searchText) else { return }
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
