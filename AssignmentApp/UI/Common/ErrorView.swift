import SwiftUI

struct ErrorView: View {
    // I didn't use localisation here, in real project - I will.
    
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
