//
//  TUCRepositoryDetailInfoCollectionViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit
import SnapKit

/// A cell for TURepositoryDetailsView. Holds value titles and cooresponding values.
final class TUCRepositoryDetailInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUCRepositoryDetailInfoCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        valueLabel.text = nil
    }

    private func setUpViews() {
        contentView.addSubview(containerView)
        titleLabel.textAlignment = .center
        valueLabel.textAlignment = .center
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        titleContainer.backgroundColor = .cyan
        containerView.addSubviews(titleContainer, valueLabel)
        titleContainer.addSubviews(titleLabel)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        titleContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.centerY.equalTo(titleContainer)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleContainer.snp.bottom)
            make.left.bottom.right.equalTo(contentView)
        }
    }

    private func setUpLayer() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUCRepositoryDetailInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
    }
}
