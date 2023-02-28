//
//  TUCRepositoryDetailUserCollectionViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit

/// A viewModel responsible for managing data of TURepositoryDetailUserCollectionViewCell.
final class TUCRepositoryDetailUserCollectionViewCellViewModel: NSObject {
    private var ownerUser: TUCOwnerUser

    // MARK: - Public Computed properties
    public var imageUrl: URL? {
        return URL(string: ownerUser.avatarImageString)
    }
    public var username: String {
        return ownerUser.name
    }
    public var userUrl: URL? {
        return URL(string: ownerUser.userUrl)
    }

    // MARK: - Init
    init(ownerUser: TUCOwnerUser) {
        self.ownerUser = ownerUser
    }
}
