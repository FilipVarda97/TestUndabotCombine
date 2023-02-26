//
//  TUCRepositoryDetailsViewController.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation
import SnapKit

/// This controller presents TURepositoryDetailsView, opens Safari or UserDetails.
final class TUCRepositoryDetailsViewController: UIViewController {
    private let viewModel: TUCRepositoryDetailsViewModel?
    private let repositoryDetailsView: TUCRepositoryDetailsView

    // MARK: - Init
    init(viewModel: TUCRepositoryDetailsViewModel) {
        self.viewModel = viewModel
        repositoryDetailsView = TUCRepositoryDetailsView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        repositoryDetailsView.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository details"
        setUpViews()
    }

    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(repositoryDetailsView)
        repositoryDetailsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TURepositoryDetailsViewDelegate
extension TUCRepositoryDetailsViewController: TUCRepositoryDetailsViewDelegate {
    func openUserDetails(from view: TUCRepositoryDetailsView, with userUrl: URL) {
        let viewModel = TUCUserDetailsViewModel(userUrl: userUrl)
        let vc = TUCUserDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func openRepository(from view: TUCRepositoryDetailsView, with repositoryUrl: URL) {
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
