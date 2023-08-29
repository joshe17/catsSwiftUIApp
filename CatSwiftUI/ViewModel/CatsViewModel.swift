//
//  CatsViewModel.swift
//  CatsInterview
//
//  Created by Joshua Ho on 8/22/23.
//

import Foundation
import Combine

enum AsyncStatus {
    case initial, loading, loaded, error
}

class CatsViewModel: ObservableObject {
    @Published var cats: [Cat] = []
    var cancellables = Set<AnyCancellable>()
    let service = CatsService()
    @Published var status: AsyncStatus = .initial
    @Published var doSort: Bool = false

    func getCats() {
        do {
            status = .loading
            try service.fetchCats()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch(completion) {
                    case .finished:
                        break;
                    case .failure(let error):
                        print(error)
                        return;
                    }
                } receiveValue: {[weak self] cats in
                    if self?.doSort == true {
                        self?.cats = cats.sorted(by: {$0.name < $1.name})
                    } else {
                        self?.cats = cats
                    }
                    self?.status = .loaded
                }
                .store(in: &cancellables)
        } catch {
            print("Invalid url: ", error)
            status = .error
        }
    }
    
    func sortCats() {
        cats.sort(by: { $0.name < $1.name })
    }
}
