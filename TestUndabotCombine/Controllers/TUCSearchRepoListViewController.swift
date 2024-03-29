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
    private let repoListView: TUCRepositoryListView
    private let viewModel: TUCRepositroyListViewViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TUCRepositroyListViewViewModel) {
        self.viewModel = viewModel
        repoListView = TUCRepositoryListView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

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
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    private func bind() {
        repoListView.openRepositoryDetails
            .receive(on: RunLoop.main)
            .sink { [weak self] repository in
                let viewModel = TUCRepositoryDetailsViewModel(repository: repository)
                let vc = TUCRepositoryDetailsViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
        repoListView.openUserDetails
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                let service = TUCService()
                let viewModel = TUCUserDetailsViewModel(userUrl: url, service: service)
                let vc = TUCUserDetailsViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cancellables)
    }
}
