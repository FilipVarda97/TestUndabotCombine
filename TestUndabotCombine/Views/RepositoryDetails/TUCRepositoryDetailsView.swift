//
//  TUCRepositoryDetailsView.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit
import Combine

/// A view that presents details about selected repository.
/// Holds UICollectionView with custom CompositionalLayout.
final class TUCRepositoryDetailsView: UIView {
    private var viewModel: TUCRepositoryDetailsViewModel
    private var collectionView: UICollectionView?
    private var cancellables = Set<AnyCancellable>()

    public var openUserAction = PassthroughSubject<URL, Never>()
    public var openRepositoryAction = PassthroughSubject<URL, Never>()

    // MARK: - Init
    init(frame: CGRect, viewModel: TUCRepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        bind()
    }

    private func bind() {
        viewModel.openRepositoryInSafari
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.openRepositoryAction.send(url)
            }.store(in: &cancellables)

        viewModel.openUserDetails
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.openUserAction.send(url)
            }.store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        collectionView = createColletionView()
        guard let collectionView = collectionView else {
            return
        }
        addSubviews(collectionView)
    }

    private func setUpConstraints() {
        guard let collectionView = collectionView else {
            return
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
        collectionView.register(TUCRepositoryDetailInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCRepositoryDetailInfoCollectionViewCell.identifier)
        collectionView.register(TUCRepositoryDetailDatesCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCRepositoryDetailDatesCollectionViewCell.identifier)
        collectionView.register(TUCRepositoryDetailUrlsCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCRepositoryDetailUrlsCollectionViewCell.identifier)
        collectionView.register(TUCRepositoryDetailUserCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUCRepositoryDetailUserCollectionViewCell.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .info:
            return viewModel.createInfoSection()
        case .dates:
            return viewModel.createDatesSection()
        case .url:
            return viewModel.createUrlSection()
        case .user:
            return viewModel.createUserSection()
        }
    }
}
