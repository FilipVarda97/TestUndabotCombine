//
//  TUCUserDetailView.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit
import Combine

/// A view that presents details about selected user.
/// Holds UICollectionView with custom CompositionalLayout.
final class TUCUserDetailView: UIView {
    private var viewModel: TUCUserDetailsViewModel
    private let input = PassthroughSubject<TUCUserDetailsViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    public let openUserDetailsInSafari = PassthroughSubject<URL, Never>()

    private var collectionView: UICollectionView?
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Init
    init(frame: CGRect, viewModel: TUCUserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView = createColletionView()
        setUpViews()
        setUpConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .startLoading:
                    self?.startLoading()
                case .didLoadUser:
                    self?.didLoadUser()
                case .failedToLoadUser:
                    self?.failedToLoadUser()
                case .openUserProfileInSafari(url: let url):
                    self?.openUserDetailsInSafari(userUrl: url)
                }
            }.store(in: &cancellables)
        input.send(.fetchUser)
    }

    private func setUpViews() {
        guard let collectionView = collectionView else {
            return
        }
        addSubviews(collectionView, spinner)
    }

    private func setUpConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        spinner.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func createColletionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TUCUserDetailPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCUserDetailPhotoCollectionViewCell.identifier)
        collectionView.register(TUCUserDetailsInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCUserDetailsInfoCollectionViewCell.identifier)
        collectionView.register(TUCUserDetailsGitCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCUserDetailsGitCollectionViewCell.identifier)
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        return collectionView
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSection()
        case .information:
            return viewModel.createInfoSection()
        case .userGitUrl:
            return viewModel.createGitSection()
        }
    }

    private func startLoading() {
        spinner.startAnimating()
        collectionView?.backgroundView = nil
    }

    private func didLoadUser() {
        spinner.stopAnimating()
        collectionView?.backgroundView = nil
        collectionView?.isHidden = false
        collectionView?.reloadData()
    }

    private func failedToLoadUser() {
        spinner.stopAnimating()
        collectionView?.isHidden = false
        collectionView?.reloadData()
        collectionView?.backgroundView = GAEmptyTableViewBackground(message: "Could not load user :/")
    }

    private func openUserDetailsInSafari(userUrl: URL) {
        openUserDetailsInSafari.send(userUrl)
    }
}
