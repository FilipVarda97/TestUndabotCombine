//
//  TUCUser.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

struct TUCUser: Codable {
    let id: Int
    let login: String
    let avatarImageString: String
    let gitProfileUrl: String
    let bio: String?
    let location: String?
    let name: String?
    let followers: Int

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarImageString = "avatar_url"
        case gitProfileUrl = "html_url"
        case bio, location, name, followers, id
    }
}
