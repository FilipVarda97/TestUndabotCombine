//
//  TUCSearchRepoListViewController.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import SnapKit

/// Initial controller for the app. This controller presents TURepositoryListView which supports searching for repos and sorting them.
final class TUCSearchRepoListViewController: UIViewController {
    private let repoListView = TUCRepositoryListView(frame: .zero)

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        setUpViews()
    }

    private func setUpViews() {
        repoListView.delegate = self
        navigationItem.searchController = repoListView.searchController
        view.backgroundColor = .systemBackground
        view.addSubview(repoListView)
        repoListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TURepositoryListViewDelegate
extension TUCSearchRepoListViewController: TUCRepositoryListViewDelegate {
    func repositoryListView(_ listView: TUCRepositoryListView, didSelectUserWith url: URL) {
        let viewModel = TUCUserDetailsViewModel(userUrl: url)
        let vc = TUCUserDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func repositoryListView(_ listView: TUCRepositoryListView, didSelectRepository repository: TUCRepository) {
        let viewModel = TUCRepositoryDetailsViewModel(repository: repository)
        let vc = TUCRepositoryDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
