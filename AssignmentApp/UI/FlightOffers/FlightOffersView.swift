import SwiftUI

struct FlightOffersView: View {
    
    @ObservedObject
    private var viewModel: FlightOffersViewModel
    
    var body: some View {
            VStack {
                makeTitleView()
                switch viewModel.state {
                case .loading:
                    makeLoadingView()
                case .error(let errorMessage):
                    makeErrorView(errorMessage: errorMessage)
                case .success(content: let content):
                    makeContentView(from: content)
                }
            }
            .onAppear {
                viewModel.loadData()
            }
    }
    
    init(viewModel: FlightOffersViewModel) {
        self.viewModel = viewModel
    }
}

private extension FlightOffersView {
    // I didn't create constants for the values here, in real project - I will
    
    func makeTitleView() -> some View {
        Text(viewModel.title)
            .foregroundColor(.green)
            .font(.system(.title, weight: .bold))
            .padding([.leading, .top, .trailing])
    }
    
    func makeLoadingView() -> some View {
        VStack {
            Spacer()
            LoadingView()
            Spacer()
        }
    }
    
    func makeErrorView(errorMessage: String) -> some View {
        VStack {
            Spacer()
            ErrorView(errorMessage: errorMessage) {
                viewModel.loadData()
            }
            Spacer()
        }
        
    }
    
    func makeContentView(from models: [FlightOfferViewModel]) -> some View {
        TabView {
            ForEach(models) {
                FlightOfferView(viewModel: $0)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
