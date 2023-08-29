//
//  ContentView.swift
//  CatSwiftUI
//
//  Created by Joshua Ho on 8/25/23.
//


import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CatsViewModel()
    var body: some View {
        VStack {
            if viewModel.cats.count == 0 {
                //Display Button
                if viewModel.status == .initial {
                    Button {
                        viewModel.getCats()
                    } label: {
                        Text("Fetch")
                    }
                } else {
                    Text("Loading Cats...")
                }
            } else {
                //Display List
                HStack {
                    Button {
                        viewModel.doSort = false
                        viewModel.getCats()
                    } label: {
                        Text("Fetch")
                    }
                    Button {
                        viewModel.doSort = true
                        viewModel.getCats()
                    } label: {
                        Text("Sort")
                    }
                }

                UIList(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
