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
    func makeTitleView() -> some View {
        Text(viewModel.title)
            .foregroundColor(.green)
            .font(.system(.title, weight: .bold))
            .padding()
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
        VStack {
            if let view = FlightOffersContentView(models: models) {
                view
            } else {
                EmptyView()
            }
        }
    }
}

private struct FlightOffersContentView: View {
    let models: [FlightOfferViewModel]
    
    @State
    private var pageSelection: String
    
    var body: some View {
        func offerViewWidth(from proxy: GeometryProxy) -> CGFloat {
            proxy.size.width * 0.9
        }
        
        return GeometryReader { proxy in
            VStack {
                TabView(selection: $pageSelection) {
                    ForEach(models) { model in
                        FlightOfferView(viewModel: model, viewWidth: offerViewWidth(from: proxy))
                            .tag(model.id)
                    }
                    .frame(width: offerViewWidth(from: proxy))
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                PageProgressView(options: models.map { $0.id }, selection: $pageSelection)
            }
        }
    }
    
    init?(models: [FlightOfferViewModel]) {
        guard let firstModel = models.first else {
            return nil
        }
        self.models = models
        self.pageSelection = firstModel.id
    }
}
