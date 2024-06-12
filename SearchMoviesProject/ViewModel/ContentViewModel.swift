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
                   let movies = try await networkService.fetchData(from: url)
                   DispatchQueue.main.async {
                       self.movieSearch = movies
                       self.isLoading = false
                   }
               } catch {
                   DispatchQueue.main.async {
                       self.isLoading = false
                       print("Failed to fetch data: \(error)")
                   }
               }
           }
       }
       
       func constructPosterURL(posterPath: String, size: String = "w45") -> URL? {
           let baseURL = "https://image.tmdb.org/t/p/"
           let fullPath = baseURL + size + posterPath
           return URL(string: fullPath)
       }
}
