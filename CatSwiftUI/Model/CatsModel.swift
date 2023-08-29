//
//  CatsModel.swift
//  CatsInterview
//
//  Created by Joshua Ho on 8/22/23.
//

import Foundation

struct Cat: Identifiable, Decodable {
    let breed: String
    let address: String
    let name: String
    let id: String
    let photo: String
}
