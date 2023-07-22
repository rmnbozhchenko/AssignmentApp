//
//  ContentView.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    private var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
            
            case .error(let errorMessage):
                Text(errorMessage)
                Spacer()
                    .frame(height: 44)
                Button("Retry") {
                    viewModel.loadData()
                }
            
            case .success(content: let citiesNames):
                List(citiesNames, id: \.self) {
                    Text($0)
                }
            }
        }
            .onAppear(perform: viewModel.loadData)
    }
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
}
