//
//  TUCUserDetailsViewModel.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit

protocol TUCUserDetailsViewModelDelegate: AnyObject {
    func startLoading()
    func didLoadUser()
    func failedToLoadUser()
    func openUserInBrowser(url: URL)
}

/// ViewModel that builds colletion view's layout for presenting UserDetails and opens a URL
/// in Safari, if provided with one.
final class TUCUserDetailsViewModel: NSObject {
    enum SectionType {
        case photo(viewModel: TUCUserDetailPhotoCollectionViewCellViewModel)
        case information(viewModels: [TUCUserDetailsInfoCollectionViewCellViewModel])
        case userGitUrl(viewModel: TUCUserDetailsGitCollectionViewCellViewModel)
    }

    public var sections: [SectionType] = []
    private var userUrl: URL?

    private var user: TUCUser? {
        didSet {
            setUpSections()
        }
    }

    weak var delegate: TUCUserDetailsViewModelDelegate? {
        didSet {
            fetchUser()
        }
    }

    // MARK: - Init
    override init() {
        super.init()
        self.userUrl = nil
    }

    convenience init(userUrl: URL) {
        self.init()
        self.userUrl = userUrl
    }

    // MARK: - Implementation
    private func fetchUser() {
//        guard let url = userUrl,
//              let tuRequest = TUCRequest(url: url) else { return }
//        delegate?.startLoading()
//        TUCService.shared.execute(tuRequest, expected: TUCUser.self) { [weak self] result  in
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async {
//                    self?.user = user
//                    self?.delegate?.didLoadUser()
//                }
//            case .failure:
//                DispatchQueue.main.async {
//                    self?.delegate?.failedToLoadUser()
//                }
//            }
//        }
    }

    private func setUpSections() {
        guard let user = user else { return }
        sections = [
            .photo(viewModel: TUCUserDetailPhotoCollectionViewCellViewModel(imageUrl: URL(string: user.avatarImageString))),
            .information(viewModels: [
                .init(type: .name, value: user.name ?? ""),
                .init(type: .bio, value: user.bio ?? ""),
                .init(type: .login, value: user.login),
                .init(type: .location, value: user.location ?? ""),
                .init(type: .followers, value: String(user.followers)),
                .init(type: .id, value: String(user.id))
            ]),
            .userGitUrl(viewModel: .init(url: user.gitProfileUrl))
        ]
    }
}

// MARK: - LayoutSetUp
extension TUCUserDetailsViewModel {
    public func createPhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.4)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createGitSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TUCUserDetailsViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photo, .userGitUrl:
            return 1
        case .information(viewModels: let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .photo(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUCUserDetailPhotoCollectionViewCell.identifier,
                                                                for: indexPath) as? TUCUserDetailPhotoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        case .information(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUCUserDetailsInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? TUCUserDetailsInfoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .userGitUrl(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUCUserDetailsGitCollectionViewCell.identifier,
                                                                for: indexPath) as? TUCUserDetailsGitCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .userGitUrl(let viewModel):
            guard let url = viewModel.urlToOpen else { return }
            delegate?.openUserInBrowser(url: url)
        }
    }
}
