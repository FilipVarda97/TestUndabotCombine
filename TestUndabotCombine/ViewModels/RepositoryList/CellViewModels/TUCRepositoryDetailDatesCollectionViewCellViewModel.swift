//
//  TUCRepositoryDetailDatesCollectionViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import Foundation

/// A viewModel responsible for managing data of TURepositoryDetailDatesCollectionViewCell and formating dates.
final class TUCRepositoryDetailDatesCollectionViewCellViewModel {
    enum `Type` {
        case lastUpdated
        case createdAt

        var title: String {
            switch self {
            case .lastUpdated:
                return "Last update"
            case .createdAt:
                return "Created at"
            }
        }
    }
    private var type: `Type`
    private let formatter = ISO8601DateFormatter()
    private var dateString: String

    // MARK: - Public Computed properties
    public var datePresentValue: String {
        guard let date = formatter.date(from: dateString) else {
            return "Corupted Date"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter.string(from: date)
    }
    public var title: String {
        return type.title
    }

    // MARK: - Init
    init(type: `Type`,  dateString: String) {
        self.type = type
        self.dateString = dateString
    }
}
