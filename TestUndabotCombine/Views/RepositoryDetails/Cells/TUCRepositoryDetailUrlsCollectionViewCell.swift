//
//  TUCRepositoryDetailUrlsCollectionViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit
import SnapKit

/// A cell for TURepositoryDetailsView. Acts as a button.
final class TUCRepositoryDetailUrlsCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUCRepositoryDetailUrlsCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan.withAlphaComponent(0.4)
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayer()
    }

    private func setUpViews() {
        contentView.addSubview(containerView)
        containerView.addSubviews(titleLabel, arrowImageView)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
    }

    private func setUpLayer() {
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: -6, height: 6)
        containerView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUCRepositoryDetailUrlsCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
    }
}
