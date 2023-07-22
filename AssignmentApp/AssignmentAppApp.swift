//
//  AssignmentAppApp.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import SwiftUI

@main
struct AssignmentAppApp: App {
    
    // I used expilcity unwrapp just for time saving, in real project it should be resolved in DI Container
    private let apiClient = try! ApiClientImpl(session: .shared,
                                               encoder: JSONEncoder(),
                                               decoder: JSONDecoder())
    
    var body: some Scene {
        WindowGroup {
            makeContentView()
        }
    }
    
    @MainActor
    private func makeContentView() -> some View {
        let viewModel = ContentViewModel(apiClient: apiClient)
        return ContentView(viewModel: viewModel)
    }
}


