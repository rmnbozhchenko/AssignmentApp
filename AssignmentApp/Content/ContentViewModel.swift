//
//  ContentViewModel.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import Foundation
import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published
    var state: ViewModelState<[String]>
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        self.state = .loading
    }
    
    func loadData() {
        state = .loading
        
        Task {
            do {
                let queryModel = PlacesQueryModel(first: 20)
                let placesResponse = try await apiClient.places(for: queryModel)
                let citiesNames = placesResponse.places.edges.map { $0.node.name }
                state = .success(content: citiesNames)
            } catch {
                handleError(error)
            }
        }
    }
}

private extension ContentViewModel {
    func handleError(_ error: Error) {
        // I am not using Localisation during this task, also error handling is pretty straightforward.
        // Just to have simple error state.
        // In real app we should show to the user more usefull text of error
        
        guard let apiClientError = error as? ApiClientError else {
            state = .error("Something was wrong")
            return
        }
        
        switch apiClientError {
            
        case .wrongApiEndpoint:
            state = .error("Wrong Api Endpoint Error")
        case .wrongDataLoading:
            state = .error("Wrong Data Loading Error")
        case .wrongQueryModel:
            state = .error("Wrong Query Model Error")
        case .wrongEncoding:
            state = .error("Wrong Encoding Error")
        case .wrongDecoding:
            state = .error("Wrong Decoding Error")
        }
    }
}
