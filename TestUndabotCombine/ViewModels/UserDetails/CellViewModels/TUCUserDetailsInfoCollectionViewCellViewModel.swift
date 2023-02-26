//
//  TUCUserDetailsInfoCollectionViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit

/// A viewModel responsible for building a cell with cooresponding title and icon of displayed value.
final class TUCUserDetailsInfoCollectionViewCellViewModel {
    enum `Type` {
        case name
        case id
        case bio
        case location
        case login
        case followers

        var title: String {
            switch self {
            case .name:
                return "Name"
            case .id:
                return "User id"
            case .bio:
                return "Bio"
            case .location:
                return "Location"
            case .login:
                return "Login id"
            case .followers:
                return "Followers"
            }
        }

        var icon: UIImage? {
            switch self {
            case .name:
                return UIImage(systemName: "person.fill")
            case .id:
                return UIImage(systemName: "number")
            case .bio:
                return UIImage(systemName: "person.text.rectangle")
            case .location:
                return UIImage(systemName: "location.fill")
            case .login:
                return UIImage(systemName: "pencil")
            case .followers:
                return UIImage(systemName: "person.2.fill")
            }
        }
    }

    private let type: `Type`
    private var value: String

    // MARK: - Public Computed properties
    public var title: String {
        return type.title
    }

    public var iconImage: UIImage? {
        return type.icon
    }

    public var displayValue: String {
        if value.isEmpty {
            return "No info"
        }
        return value
    }

    // MARK: - Init
    init(type: `Type`,  value: String) {
        self.type = type
        self.value = value
    }
}
