//
//  TUCUserDetailsViewController.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit

/// This controller presents TUUserDetailView and opens Safari.
final class TUCUserDetailsViewController: UIViewController {
    private let userDetailsView: TUCUserDetailView
    private let viewModel: TUCUserDetailsViewModel

    // MARK: - Init
    init(viewModel: TUCUserDetailsViewModel) {
        self.viewModel = viewModel
        self.userDetailsView = TUCUserDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.userDetailsView.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User details"
        setUpViews()
    }

    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(userDetailsView)
        userDetailsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TUUserDetailViewDelegate
extension TUCUserDetailsViewController: TUCUserDetailViewDelegate {
    func openUser(from view: TUCUserDetailView, with userUrl: URL) {
        let alertController = UIAlertController(title: "Open in Safari",
                                                message: "Are you sure that you want to open this link in Safari?",
                                                preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        let actionsYes = UIAlertAction(title: "YES", style: .default, handler: { _ in
            UIApplication.shared.open(userUrl)
        })
        alertController.addAction(actionsYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true)
    }
}
