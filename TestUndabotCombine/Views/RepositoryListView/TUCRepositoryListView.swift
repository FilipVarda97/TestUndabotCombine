//
//  TUCRepositoryListView.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit

protocol TUCRepositoryListViewDelegate: AnyObject {
    func repositoryListView(_ listView: TUCRepositoryListView, didSelectUserWith url: URL)
    func repositoryListView(_ listView: TUCRepositoryListView, didSelectRepository repository: TUCRepository)
}

/// A view holding a table view that presents cells with repository information,
/// and UISearchController with it's ScopeButtons.
final class TUCRepositoryListView: UIView {
    private let viewModel = TUCRepositroyListViewViewModel()
    weak var delegate: TUCRepositoryListViewDelegate?

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
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
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
        viewModel.delegate = self
        searchController.searchResultsUpdater = viewModel
        searchController.searchBar.delegate = viewModel
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

// MARK: - TURepositroyListViewViewModelDelegate
extension TUCRepositoryListView: TUCRepositroyListViewViewModelDelegate {
    func openUserDetails(userUrl: URL) {
        delegate?.repositoryListView(self, didSelectUserWith: userUrl)
    }

    func openRepositoryDetails(repository: TUCRepository) {
        delegate?.repositoryListView(self, didSelectRepository: repository)
    }

    func beginLoadingRepositories() {
        spinner.startAnimating()
        tableView.backgroundView = nil
    }

    func failedToLoadSearchRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
        tableView.backgroundView = TUCEmptyTableViewBackground()
    }

    func finishedLoadingOrSortingRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
    }
}
