import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkService: NetworkService
    @State private var searchText: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter search criteria", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                Button(action: {
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        if let url = URL(string:"https://api.themoviedb.org/3/search/movie?query=\(searchText)") {
                            do {
                                _ = try await networkService.fetchData(from: url)
                            } catch {
                                print("Failed to fetch data: \(error)")
                            }
                        }
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.teal)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                List(networkService.movieSearch?.results ?? []) { result in
                    Text(result.title)
                }
            }
            
            Spacer()
        }
        .background(Color.pink.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    ContentView()
}
