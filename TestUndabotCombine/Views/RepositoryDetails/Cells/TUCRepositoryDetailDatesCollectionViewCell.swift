//
//  TUCRepositoryDetailDatesCollectionViewCell.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//
// swiftlint:disable type_name

import UIKit
import SnapKit

/// A cell for TURepositoryDetailsView. Holds dates titles and cooresponding date strings.
final class TUCRepositoryDetailDatesCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUCRepositoryDetailDatesCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar.badge.clock")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
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
        containerView.addSubviews(titleLabel,
                                  valueLabel,
                                  iconImageView)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        valueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }

    private func setUpLayer() {
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUCRepositoryDetailDatesCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.datePresentValue
    }
}
