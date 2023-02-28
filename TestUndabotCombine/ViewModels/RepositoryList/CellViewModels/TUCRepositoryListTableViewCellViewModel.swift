//
//  TUCRepositoryListTableViewCellViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

/// A viewModel responsible for managing data of TURepositoryListTableViewCell.
final class TUCRepositoryListTableViewCellViewModel {
    private let repository: TUCRepository

    // MARK: - Public calculated properties
    public var id: Int {
        return repository.id
    }
    public var avatarURL: URL? {
        return URL(string: repository.ownerUser.avatarImageString)
    }
    public var repositoryTitle: String {
        return repository.name
    }
    public var authorName: String {
        return repository.ownerUser.name
    }
    public var userUrl: URL? {
        return URL(string: repository.ownerUser.userUrl)
    }
    public var repositoryUrl: String {
        return repository.repositoryUrl
    }
    public var starsCountText: String {
        return "Stars: \(repository.stargazersCount)"
    }
    public var watchersCountText: String {
        return "Watchers: \(repository.watchersCount)"
    }
    public var forksCountText: String {
        return "Forks: \(repository.forksCount)"
    }
    public var issuesCountText: String {
        return "Open issues: \(repository.openIssuesCount)"
    }
    public var detailedRepository: TUCRepository {
        return repository
    }

    // MARK: - Init
    init(repository: TUCRepository) {
        self.repository = repository
    }
}
