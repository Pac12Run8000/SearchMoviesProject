import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkService: NetworkService
    @StateObject private var viewModel: ContentViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ContentViewModel(networkService: NetworkService(token: "token_4435356")))
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter search criteria", text: $viewModel.searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                
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
                // Here is the base url with width https://image.tmdb.org/t/p/w45
                List(viewModel.movieSearch?.results ?? []) { result in
                    Text("\(result.title), poster path: \(result.posterPath)")
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
