import Foundation

class NetworkService: ObservableObject, NetworkServiceProtocol {
    @Published var movieSearch: MovieSearch?
    private let token: String

    init(token: String) {
        self.token = token
    }
    
    func fetchData(from url: URL) async throws -> MovieSearch {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(MovieSearch.self, from: data)
        DispatchQueue.main.async {
            self.movieSearch = decodedData
        }
        return decodedData
    }
}
