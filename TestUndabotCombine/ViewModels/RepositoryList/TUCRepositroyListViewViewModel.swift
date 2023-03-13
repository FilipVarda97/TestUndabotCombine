//
//  TUCRepositroyListViewViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import Combine

/// A viewModel that fetches all repositories and searches for them using searchController.
/// The viewModel is also responsible for sorting/filtering results based on selected index of ScopeButton.
final class TUCRepositroyListViewViewModel: NSObject {

    // MARK: - Properties
    enum Input {
        case searchButtonPress(withText: String?)
        case cancelButtonPressed
        case sortPressed(selectedIndex: Int)
    }
    enum Output {
        case didBeginLoading
        case failedToLoadSearchRepositories
        case finishedLoadingOrSortingRepositories
        case cancelSearch
        case openUserDetails(userUrl: URL)
        case openRepositoryDetils(repository: TUCRepository)
    }
    enum SortType {
        case stars
        case forks
        case updated

        init(_ index: Int) {
            switch index {
            case 0: self = .stars
            case 1: self = .forks
            case 2: self = .updated
            default: self = .stars
            }
        }
    }

    private var sortedRepositories: [TUCRepository] = [] {
        didSet {
            cellViewModels.removeAll()
            for repository in sortedRepositories {
                let viewModel = TUCRepositoryListTableViewCellViewModel(repository: repository)
                cellViewModels.append(viewModel)
            }
        }
    }

    private var cellViewModels: [TUCRepositoryListTableViewCellViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    private var sortType: SortType = .stars
    private var isLoadingSearchRepositories = false
    private var shouldInitialScreenPresent = true
    private var repositories: [TUCRepository] = []
    private let service: ServiceExecutable

    // MARK: - Init
    init(service: ServiceExecutable) {
        self.service = service
        super.init()
    }

    // MARK: - Implementation
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .searchButtonPress(withText: let name):
                    self?.fetchRepositories(using: name)
                case .sortPressed(selectedIndex: let index):
                    self?.sortType = .init(index)
                    self?.sortRepositories()
                case .cancelButtonPressed:
                    self?.cancelButtonPressed()
                }
            }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func fetchRepositories(using searchName: String?) {
        guard let name = searchName, !name.isEmpty else { return }
        if !isLoadingSearchRepositories {
            let queryParams = [
                URLQueryItem(name: "q", value: name)
            ]
            let tucRequest = TUCRequest(enpoint: .searchRepositories, queryParams: queryParams)
            isLoadingSearchRepositories = true
            shouldInitialScreenPresent = false
            output.send(.didBeginLoading)
            service.execute(tucRequest, expected: TUCRepositoriesResponse.self)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.failLoadingRepositories()
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] result in
                    if result.totalCount <= 0 {
                        self?.failLoadingRepositories()
                        return
                    }
                    self?.repositories = result.items
                    self?.isLoadingSearchRepositories = false
                    self?.sortRepositories()
                }).store(in: &cancellables)
        }
    }

    private func sortRepositories() {
        switch sortType {
        case .stars:
            sortedRepositories = repositories.sorted(by: { $0.stargazersCount > $1.stargazersCount })
        case .forks:
            sortedRepositories = repositories.sorted(by: { $0.forksCount > $1.forksCount })
        case .updated:
            let dateFormatter = ISO8601DateFormatter()
            sortedRepositories = repositories.sorted {
                guard let firstDate = dateFormatter.date(from: $0.updatedAt),
                      let secondDate = dateFormatter.date(from: $1.updatedAt) else {
                    return false
                }
                return firstDate > secondDate
            }
            // MARK: [TEST] - Uncomment to print sorted array of dates since "TURepository.updatedAt" is not preseneted on UI.
            // print(sortedRepositories.compactMap { return $0.updatedAt })
        }
        output.send(.finishedLoadingOrSortingRepositories)
    }

    private func cancelButtonPressed() {
        shouldInitialScreenPresent = true
        repositories.removeAll()
        cellViewModels.removeAll()
        output.send(.cancelSearch)
    }

    private func failLoadingRepositories() {
        repositories.removeAll()
        cellViewModels.removeAll()
        isLoadingSearchRepositories = false
        output.send(.failedToLoadSearchRepositories)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TUCRepositroyListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellViewModels.isEmpty && shouldInitialScreenPresent {
            tableView.backgroundView = GAEmptyTableViewBackground(message: "Try searching for repo.")
            return 0
        }
        tableView.backgroundView = nil
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TUCRepositoryListTableViewCell.identifier) as? TUCRepositoryListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cellViewModels[indexPath.row])

        cell.userTapSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] userUrl in
                self?.output.send(.openUserDetails(userUrl: userUrl))
            }.store(in: &cell.cancellables)
        cell.repositoryTapSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] repository in
                self?.output.send(.openRepositoryDetils(repository: repository))
            }.store(in: &cell.cancellables)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
