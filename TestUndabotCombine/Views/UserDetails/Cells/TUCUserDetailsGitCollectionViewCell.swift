//
//  TUCUserDetailsGitCollectionViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation
import SnapKit

/// A cell for TUUserDetailView. Holds a URL of the user profile.
final class TUCUserDetailsGitCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUCUserDetailsGitCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpLayer()
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
        titleLabel.text = nil
        urlLabel.text = nil
    }

    private func setUpViews() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        contentView.addSubviews(containerView)
        containerView.addSubviews(titleContainerView, urlLabel)
        titleContainerView.addSubviews(iconImageView, titleLabel)
        titleContainerView.backgroundColor = .cyan
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        titleContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(titleContainerView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.centerY.equalTo(titleContainerView)
        }
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(titleContainerView.snp.bottom)
            make.left.bottom.right.equalTo(containerView)
        }
    }

    private func setUpLayer() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUCUserDetailsGitCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.iconImage
        urlLabel.text = viewModel.urlString
    }
}
