//
//  SearchMoviesProjectApp.swift
//  SearchMoviesProject
//
//  Created by Norbert Grover on 6/10/24.
//

import SwiftUI

@main
struct SearchMoviesProjectApp: App {
    @StateObject private var networkService = NetworkService(token: "")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkService)
        }
    }
}
