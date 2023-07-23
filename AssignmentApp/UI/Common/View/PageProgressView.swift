import SwiftUI

struct PageProgressView<SelectionValue>: View where SelectionValue: Hashable {
    private let options: [SelectionValue]
    
    @Binding
    private var selection: SelectionValue
    
    var body: some View {
        HStack() {
            ForEach(options, id: \.self) { option in
                Circle()
                    .fill(option == selection ? Color.gray : Color.gray.opacity(0.2))
                    .frame(width: 20, height: 20)
            }
        }
        .padding()
    }
    
    init(options: [SelectionValue], selection: Binding<SelectionValue>) {
        self.options = options
        self._selection = selection
    }
}
