//
//  TUCRepositoryListTableViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit
import Kingfisher
import SnapKit
import Combine

/// A table view cell that represents a repository item in a TURepositoryListView.
/// Press on image opens user details, press on text open repo details.
class TUCRepositoryListTableViewCell: UITableViewCell {
    static let identifier = "TURepositoryListTableViewCell"
    private var viewModel: TUCRepositoryListTableViewCellViewModel?

    public var userTapSubject = PassthroughSubject<URL, Never>()
    public var repositoryTapSubject = PassthroughSubject<TUCRepository, Never>()
    public var cancellables = Set<AnyCancellable>()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let textContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let numberOfWatchersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let numberOfForksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let numberOfIssuesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let numberOfStarsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let authorAvatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        repositoryNameLabel.text = nil
        authorNameLabel.text = nil
        numberOfWatchersLabel.text = nil
        numberOfForksLabel.text = nil
        numberOfIssuesLabel.text = nil
        numberOfStarsLabel.text = nil
        authorAvatarImageView.image = nil
        cancellables.removeAll()
    }

    private func setUpViews() {
        contentView.addSubview(containerView)
        containerView.addSubviews(authorAvatarImageView,
                                  textContainerView)
        textContainerView.addSubviews(repositoryNameLabel,
                                      authorNameLabel,
                                      numberOfForksLabel,
                                      numberOfIssuesLabel,
                                      numberOfWatchersLabel,
                                      numberOfStarsLabel)

        let tapImage = UITapGestureRecognizer(target: self, action: #selector(openUserDetails))
        let tapText = UITapGestureRecognizer(target: self, action: #selector(openRepositoryDetails))
        authorAvatarImageView.addGestureRecognizer(tapImage)
        authorAvatarImageView.isUserInteractionEnabled = true
        textContainerView.addGestureRecognizer(tapText)
        textContainerView.isUserInteractionEnabled = true
    }

    private func setUpConstraints() {
        containerView.backgroundColor = .cyan.withAlphaComponent(0.4)
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        authorAvatarImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.height.width.equalTo(containerView.snp.height)
        }
        textContainerView.snp.makeConstraints { make in
            make.left.equalTo(authorAvatarImageView.snp.right).offset(10)
            make.top.right.bottom.equalToSuperview()
        }
        repositoryNameLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.left.equalTo(authorAvatarImageView.snp.right).offset(10)
        }
        authorNameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(repositoryNameLabel.snp.bottom).offset(2)
            make.left.equalTo(authorAvatarImageView.snp.right).offset(10)
        }
        numberOfWatchersLabel.snp.makeConstraints { make in
            make.top.equalTo(authorNameLabel.snp.bottom).offset(5)
            make.left.equalTo(authorAvatarImageView.snp.right).offset(10)
        }
        numberOfForksLabel.snp.makeConstraints { make in
            make.top.equalTo(numberOfWatchersLabel.snp.top)
            make.left.equalTo(numberOfWatchersLabel.snp.right).offset(10)
        }
        numberOfIssuesLabel.snp.makeConstraints { make in
            make.top.equalTo(numberOfWatchersLabel.snp.bottom).offset(2)
            make.left.equalTo(authorAvatarImageView.snp.right).offset(10)
        }
        numberOfStarsLabel.snp.makeConstraints { make in
            make.top.equalTo(numberOfForksLabel.snp.bottom).offset(2)
            make.left.equalTo(numberOfIssuesLabel.snp.right).offset(10)
        }
    }

    public func configure(with viewModel: TUCRepositoryListTableViewCellViewModel) {
        self.viewModel = viewModel
        repositoryNameLabel.text = viewModel.repositoryTitle
        authorNameLabel.text = viewModel.authorName
        numberOfWatchersLabel.text = viewModel.watchersCountText
        numberOfForksLabel.text = viewModel.forksCountText
        numberOfIssuesLabel.text = viewModel.issuesCountText
        numberOfStarsLabel.text = viewModel.starsCountText

        let placeholder = UIImage(systemName: "person.fill")
        authorAvatarImageView.kf.indicatorType = .activity
        authorAvatarImageView.kf.setImage(with: viewModel.avatarURL,
                                          placeholder: placeholder,
                                          options: [.transition(.flipFromLeft(0.2))])
    }

    private func setUpLayer() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }

    // MARK: - Actions
    @objc private func openUserDetails() {
        guard let url = viewModel?.userUrl else { return }
        userTapSubject.send(url)
    }

    @objc private func openRepositoryDetails() {
        guard let repository = viewModel?.detailedRepository else { return }
        repositoryTapSubject.send(repository)
    }
}
