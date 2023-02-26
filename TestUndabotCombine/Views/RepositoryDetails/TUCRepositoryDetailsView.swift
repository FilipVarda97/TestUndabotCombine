//
//  TUCRepositoryDetailsView.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import SnapKit

protocol TUCRepositoryDetailsViewDelegate: AnyObject {
    func openRepository(from view: TUCRepositoryDetailsView, with repositoryUrl: URL)
    func openUserDetails(from view: TUCRepositoryDetailsView, with userUrl: URL)
}

/// A view that presents details about selected repository.
/// Holds UICollectionView with custom CompositionalLayout.
final class TUCRepositoryDetailsView: UIView {
    weak var delegate: TUCRepositoryDetailsViewDelegate?
    private var viewModel: TUCRepositoryDetailsViewModel

    private var collectionView: UICollectionView?

    // MARK: - Init
    init(frame: CGRect, viewModel: TUCRepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.delegate = self
        setUpViews()
        setUpConstraints()
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

// MARK: - TURepositoryDetailsViewModelDelegate
extension TUCRepositoryDetailsView: TUCRepositoryDetailsViewModelDelegate {
    func openUserDetails(with url: URL) {
        delegate?.openUserDetails(from: self, with: url)
    }

    func openRepositoryInBrowser(url: URL) {
        delegate?.openRepository(from: self, with: url)
    }
}
