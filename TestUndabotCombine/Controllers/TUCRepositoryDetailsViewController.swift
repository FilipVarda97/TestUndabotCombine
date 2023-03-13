//
//  TUCRepositoryDetailsViewController.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation
import SnapKit
import Combine

/// This controller presents TURepositoryDetailsView, opens Safari or UserDetails.
final class TUCRepositoryDetailsViewController: UIViewController {
    private let viewModel: TUCRepositoryDetailsViewModel?
    private let repositoryDetailsView: TUCRepositoryDetailsView
    private var cancellabels = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: TUCRepositoryDetailsViewModel) {
        self.viewModel = viewModel
        repositoryDetailsView = TUCRepositoryDetailsView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository details"
        setUpViews()
        bind()
    }

    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(repositoryDetailsView)
        repositoryDetailsView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    private func bind() {
        repositoryDetailsView.openUserAction
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.openUserDetails(with: url)
            }.store(in: &cancellabels)

        repositoryDetailsView.openRepositoryAction
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.openRepository(with: url)
            }.store(in: &cancellabels)
    }

    private func openUserDetails(with userUrl: URL) {
        let service = TUCService()
        let viewModel = TUCUserDetailsViewModel(userUrl: userUrl, service: service)
        let vc = TUCUserDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openRepository(with repositoryUrl: URL) {
        let alertController = UIAlertController(title: "Open in Safari",
                                                message: "Are you sure that you want to open this link in Safari?",
                                                preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        let actionsYes = UIAlertAction(title: "YES", style: .default, handler: { _ in
            UIApplication.shared.open(repositoryUrl)
        })
        alertController.addAction(actionsYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true)
    }
}
