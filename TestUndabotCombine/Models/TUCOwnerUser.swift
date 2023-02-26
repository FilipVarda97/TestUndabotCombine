//
//  TUCOwnerUser.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

struct TUCOwnerUser: Codable {
    let name: String
    let avatarImageString: String
    let userUrl: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarImageString = "avatar_url"
        case userUrl = "url"
    }
}
