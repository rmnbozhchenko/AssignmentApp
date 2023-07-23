import Foundation
import SwiftUI

@MainActor
final class FlightOffersViewModel: ObservableObject {
    // I didn't use localisation here, in real project - I will.
    // Also I didn't create constants for the values
    
    let title = "flight offers".uppercased()
    
    @Published
    var state: ViewModelState<[FlightOfferViewModel]>
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        self.state = .loading
    }
    
    func loadData() {
        state = .loading
        
        Task {
            do {
                let placesQueryModel = PlacesQueryModel(term: "", first: 5)
                let placesResponse = try await apiClient.places(for: placesQueryModel)
                let citiesIds = placesResponse.places.edges.map { $0.node.id }
                
                let flightsQueryModel = FlightsQueryModel(limit: 5,
                                                          currency: "EUR",
                                                          sources: citiesIds,
                                                          destinations: [],
                                                          departureStart: "2023-08-01T00:00:00",
                                                          departureEnd: "2023-08-01T23:59:00")
                let flightsResponse = try await apiClient.flights(for: flightsQueryModel)
                let content = flightsResponse.mapToViewModels()
                self.state = .success(content: content)
            } catch {
                handleError(error)
            }
        }
    }
}

private extension FlightOffersViewModel {
    func handleError(_ error: Error) {
        // I am not using Localisation during this task, also error handling is pretty straightforward.
        // Just to have simple error state.
        // In real app we should show to the user more usefull text of error
        
        if let apiClientError = error as? ApiClientError {
            switch apiClientError {
            case .wrongApiEndpoint:
                print(error) // should be handled Wrong Api Endpoint Error
            case .wrongDataLoading:
                print(error) // should be handled Wrong Data Loading Error
            case .wrongQueryModel:
                print(error) // should be handled Wrong Query Model Error
            case .wrongEncoding:
                print(error) // should be handled Wrong Encoding Error
            case .wrongDecoding:
                print(error) // should be handled Wrong Decoding Error
            }
        }
        
        state = .error("Something was wrong, please try again later.")
    }
}
