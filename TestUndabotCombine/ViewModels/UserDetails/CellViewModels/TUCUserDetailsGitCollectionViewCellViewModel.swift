//
//  TUCUserDetailsGitCollectionViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit

/// A viewModel responsible for calculation presentable values and createing an URL form url.
final class TUCUserDetailsGitCollectionViewCellViewModel {
    private var url: String

    // MARK: - Public Computed properties
    public var title: String {
        return "Git profile"
    }
    public var iconImage: UIImage? {
        return UIImage(systemName: "safari.fill")
    }
    public var urlToOpen: URL? {
        return URL(string: url)
    }
    public var urlString: String {
        return url
    }

    // MARK: - Init
    init(url: String) {
        self.url = url
    }
}
