//
//  ContentView.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    private let viewModel: ContentViewModel
    
    var body: some View {
        VStack {}
            .onAppear(perform: viewModel.loadData)
    }
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
}
