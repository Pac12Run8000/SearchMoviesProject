import Foundation

protocol NetworkServiceProtocol {
    func fetchData(from url: URL) async throws -> MovieSearch
}
