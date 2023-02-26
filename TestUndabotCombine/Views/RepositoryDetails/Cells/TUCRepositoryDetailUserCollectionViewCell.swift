//
//  TUCRepositoryDetailUserCollectionViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import Foundation
import Kingfisher
import SnapKit

/// A cell for TURepositoryDetailsView. Presents user data and
/// acts as a button for opening UserDetails.
final class TUCRepositoryDetailUserCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUCRepositoryDetailUserCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan.withAlphaComponent(0.4)
        return view
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        usernameLabel.text = nil
        ownerImageView.image = nil
    }

    private func setUpViews() {
        contentView.addSubview(containerView)
        containerView.addSubviews(ownerImageView,
                                  usernameLabel,
                                  arrowImageView)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        ownerImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(containerView.snp.height)
        }
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ownerImageView.snp.right).offset(20)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
    }

    private func setUpLayer() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: -6, height: 6)
        containerView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUCRepositoryDetailUserCollectionViewCellViewModel) {
        let placeholder = UIImage(systemName: "person.fill")
        ownerImageView.kf.indicatorType = .activity
        ownerImageView.kf.setImage(with: viewModel.imageUrl,
                                          placeholder: placeholder,
                                          options: [.transition(.flipFromLeft(0.2))])
        usernameLabel.text = viewModel.username
    }
}
