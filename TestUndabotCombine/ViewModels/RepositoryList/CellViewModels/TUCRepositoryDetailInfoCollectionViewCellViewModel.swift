//
//  TUCRepositoryDetailInfoCollectionViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit

/// A viewModel responsible for managing data of TURepositoryDetailInfoCollectionView.
final class TUCRepositoryDetailInfoCollectionViewCellViewModel {
    enum `Type` {
        case watchersCount
        case forksCount
        case starsCount
        case openIssuesCount
        case name
        case authorName

        var title: String {
            switch self {
            case .watchersCount:
                return "Watchers"
            case .forksCount:
                return "Forks"
            case .starsCount:
                return "Stars"
            case .openIssuesCount:
                return "Open issues"
            case .name:
                return "Name"
            case .authorName:
                return "Author username"
            }
        }
    }

    private let type: `Type`
    private var value: String

    // MARK: - Public Computed properties
    public var title: String {
        return type.title
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
