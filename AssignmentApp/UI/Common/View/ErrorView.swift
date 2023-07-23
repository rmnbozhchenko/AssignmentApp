import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(errorMessage)
                .font(.title2)
                .padding()
            Button("Retry", action: retryAction)
        }
    }
}
