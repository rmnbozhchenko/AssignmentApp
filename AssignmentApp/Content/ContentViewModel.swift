//
//  ContentViewModel.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import Foundation

final class ContentViewModel {
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func loadData() {
        Task {
            do {
                let queryModel = PlacesQueryModel(first: 20)
                let placesResponse = try await apiClient.places(for: queryModel)
                let citiesNames = placesResponse.places.edges.map { $0.node.name }
                print(citiesNames)
            } catch {
                print(error)
            }
        }
    }
}
