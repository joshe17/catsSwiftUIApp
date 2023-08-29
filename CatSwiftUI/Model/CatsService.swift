//
//  CatsService.swift
//  CatsInterview
//
//  Created by Joshua Ho on 8/22/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidUrl, invalidResponse, decodingError
}

class CatsService {
    let urlString = "https://647e1a94af984710854af0ac.mockapi.io/api/v1/Cats"
    
    func fetchCats() throws -> AnyPublisher<[Cat], Error> {
        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else { throw APIError.invalidResponse }
                return data
            }
            .decode(type: [Cat].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
