import Foundation
import SwiftUI

private enum Constants {
    // Now all constants are static,
    // but of course they could be used from the user input.
    static let title = "flight offers".uppercased()
    
    static let generalErrorMessage = "Something was wrong, please try again later."
    
    static let placesTerm = ""
    static let placesCount = 5
    
    static let flightsCount = 5
    static let flightsCurrency = "EUR"
    static let flightsDestinations = [String]()
}

@MainActor
final class FlightOffersViewModel: ObservableObject {
    let title = Constants.title
    
    @Published
    var state: ViewModelState<[FlightOfferViewModel]>
    
    private let apiClient: ApiClient
    private let departureDateFilter: DepartureDateFilter
    
    init(apiClient: ApiClient, departureDateFilter: DepartureDateFilter) {
        self.apiClient = apiClient
        self.departureDateFilter = departureDateFilter
        self.state = .loading
    }
    
    func loadData() {
        state = .loading
        
        Task {
            do {
                let placesQueryModel = PlacesQueryModel(term: Constants.placesTerm,
                                                        first: Constants.placesCount)
                let placesResponse = try await apiClient.places(for: placesQueryModel)
                let citiesIds = placesResponse.places.edges.map { $0.node.id }
                
                let departureDate = departureDateFilter.departureDate()
                
                let flightsQueryModel = FlightsQueryModel(limit: Constants.flightsCount,
                                                          currency: Constants.flightsCurrency,
                                                          sources: citiesIds,
                                                          destinations: Constants.flightsDestinations,
                                                          departureStart: departureDate.startDateString,
                                                          departureEnd: departureDate.endDateString)
                let flightsResponse = try await apiClient.flights(for: flightsQueryModel)
                let content = flightsResponse.mapToViewModels(imageUrlMaker: apiClient.imageUrl(for:))
                self.state = .success(content: content)
            } catch {
                handleError(error)
            }
        }
    }
}

private extension FlightOffersViewModel {
    func handleError(_ error: Error) {
        // Error handling here is pretty straightforward.
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
        
        state = .error(Constants.generalErrorMessage)
    }
}
