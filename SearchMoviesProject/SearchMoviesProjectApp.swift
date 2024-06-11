//
//  SearchMoviesProjectApp.swift
//  SearchMoviesProject
//
//  Created by Norbert Grover on 6/10/24.
//

import SwiftUI

@main
struct SearchMoviesProjectApp: App {
    @StateObject private var networkService = NetworkService(token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYWZmMGYyYTJlMDUxOTMyNzk2ODYxZGI2YTI0NmQ3NSIsInN1YiI6IjU5MzY5N2UyOTI1MTQxNmJlZTAwZDA2ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IZZ_QnAvoat2CoJDtjgQZxpcyrLVW7qQBLx3OHvYgHU")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkService)
        }
    }
}
