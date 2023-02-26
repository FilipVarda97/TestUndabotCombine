//
//  TUCRepositoriesResponse.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

struct TUCRepositoriesResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [TUCRepository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
