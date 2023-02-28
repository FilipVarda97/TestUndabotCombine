//
//  TUCRepositoryListView.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit
import Combine

/// A view holding a table view that presents cells with repository information,
/// and UISearchController with it's ScopeButtons.
final class TUCRepositoryListView: UIView {
    private let viewModel = TUCRepositroyListViewViewModel()
    private let input = PassthroughSubject<TUCRepositroyListViewViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    public let openUserDetails = PassthroughSubject<URL, Never>()
    public let openRepositoryDetails = PassthroughSubject<TUCRepository, Never>()

    public let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Repository name"
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Stars", "Forks", "Updated"]
        searchController.searchBar.backgroundColor = .systemBackground
        return searchController
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TUCRepositoryListTableViewCell.self,
                       forCellReuseIdentifier: TUCRepositoryListTableViewCell.identifier)
        table.keyboardDismissMode = .onDrag
        table.separatorStyle = .none
        return table
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        return spinner
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        configureView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { event in
                switch event {
                case .didBeginLoading:
                    self.beginLoadingRepositories()
                case .failedToLoadSearchRepositories:
                    self.failedToLoadSearchRepositories()
                case .finishedLoadingOrSortingRepositories:
                    self.finishedLoadingOrSortingRepositories()
                case .openUserDetails(userUrl: let userUrl):
                    self.openUserDetails(userUrl: userUrl)
                case .openRepositoryDetils(repository: let repository):
                    self.openRepositoryDetails(repository: repository)
                }
            }.store(in: &cancellables)
    }

    private func setUpViews() {
        addSubviews(tableView, spinner)
    }

    private func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }

    private func configureView() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }

    // MARK: - Output
    private func beginLoadingRepositories() {
        spinner.startAnimating()
        tableView.backgroundView = nil
    }

    private func failedToLoadSearchRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
        tableView.backgroundView = TUCEmptyTableViewBackground()
    }

    private func finishedLoadingOrSortingRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
    }

    private func openUserDetails(userUrl: URL) {
        openUserDetails.send(userUrl)
    }

    private func openRepositoryDetails(repository: TUCRepository) {
        openRepositoryDetails.send(repository)
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension TUCRepositoryListView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        input.send(.searchButtonPress(withText: searchController.searchBar.text))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        input.send(.searchButtonPress(withText: searchBar.text))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        input.send(.cancelButtonPressed)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        input.send(.sortPressed(selectedIndex: selectedScope))
    }
}
