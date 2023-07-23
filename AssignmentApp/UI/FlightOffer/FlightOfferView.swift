import SwiftUI

struct FlightOfferView: View {
    
    let viewModel: FlightOfferViewModel
    
    var body: some View {
        VStack {
            makeContentView()
            Spacer()
        }
    }
}

private extension FlightOfferView {
    // I didn't create constants for the values here, in real project - I will
    
    func makeImageView() -> some View {
        AsyncImage(url: viewModel.imageUrl,
                   content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }, placeholder: {
            Color.gray
        })
    }
    
    func makeDetailsView() -> some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .lineLimit(2)
                    .font(.system(.title, weight: .bold))
                Spacer()
                Text(viewModel.price)
                    .lineLimit(1)
                    .font(.system(.title, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.bottom)
            HStack {
                Text(viewModel.subtitle)
                    .font(.system(.headline, weight: .bold))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding()
    }
    
    func makeContentView() -> some View {
        VStack {
            makeImageView()
            makeDetailsView()
        }
        .background(.gray.opacity(0.2))
        .cornerRadius(30)
        .padding([.leading, .top, .trailing])
    }
}
