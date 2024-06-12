import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkService: NetworkService
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter search criteria", text: $viewModel.searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                Button(action: {
                    viewModel.searchMovies()
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.teal)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                List(viewModel.movieSearch?.results ?? []) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.headline)
                        
                        if let posterPath = result.posterPath, let url = viewModel.constructPosterURL(posterPath: posterPath) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    Image(systemName: "photo")
                                }
                            }
                            .frame(height: 200)
                        } else {
                            Image(systemName: "photo")
                                .frame(height: 200)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .background(Color.pink.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.networkService = networkService
        }
    }
}

#Preview {
    ContentView()
}
