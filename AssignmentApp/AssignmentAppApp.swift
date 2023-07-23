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
        let viewModel = FlightOffersViewModel(apiClient: apiClient)
        return FlightOffersView(viewModel: viewModel)
    }
}


