import SwiftUI

@main
struct AssignmentAppApp: App {
    // I used expilcity unwrapp just for time saving,
    // in real project it should be resolved in DI Container
    
    private let apiClient = try! ApiClientImpl(session: .shared,
                                               encoder: JSONEncoder(),
                                               decoder: JSONDecoder())
    private let dateFormatter = DateFormatter.makeAppDateFormatter()
    
    var body: some Scene {
        WindowGroup {
            makeContentView()
        }
    }
    
    @MainActor
    private func makeContentView() -> some View {
        let departureDateFilter = DepartureDateFilterImpl(dateFormatter: dateFormatter)
        let viewModel = FlightOffersViewModel(apiClient: apiClient,
                                              departureDateFilter: departureDateFilter)
        return FlightOffersView(viewModel: viewModel)
    }
}


