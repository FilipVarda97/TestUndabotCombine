//
//  TUCSearchRepoListViewController.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import SnapKit
import Combine

/// Initial controller for the app. This controller presents TURepositoryListView which supports searching for repos and sorting them.
final class TUCSearchRepoListViewController: UIViewController {
    private let repoListView = TUCRepositoryListView(frame: .zero)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        setUpViews()
        bind()
    }

    private func setUpViews() {
        navigationItem.searchController = repoListView.searchController
        view.backgroundColor = .systemBackground
        view.addSubview(repoListView)
        repoListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bind() {
        repoListView.openRepositoryDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repository in
                let viewModel = TUCRepositoryDetailsViewModel(repository: repository)
                let vc = TUCRepositoryDetailsViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
        repoListView.openUserDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                let viewModel = TUCUserDetailsViewModel(userUrl: url)
                let vc = TUCUserDetailsViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
    }
}
