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
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(MovieSearch.self, from: data)
        await MainActor.run {
            self.movieSearch = decodedData
        }
        return decodedData
    }
    
    func fetchDataWithRetry(from url: URL, retries: Int, delay: TimeInterval) async throws -> MovieSearch {
            var attempts = 0
            var lastError: Error?

            while attempts < retries {
                do {
                    return try await fetchData(from: url)
                } catch {
                    lastError = error
                    attempts += 1
                    print("Attempt \(attempts) failed: \(error.localizedDescription)")
                    if attempts < retries {
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    }
                }
            }

            if let lastError = lastError {
                throw lastError
            } else {
                throw URLError(.unknown)
            }
        }
}
