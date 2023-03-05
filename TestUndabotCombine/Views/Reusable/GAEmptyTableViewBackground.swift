//
//  TUCEmptyTableViewBackground.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import UIKit

/// Background view of UITableView. Can init with custom message or default "No data?".
final class GAEmptyTableViewBackground: UIView {
    private var message: String = "Something went wrong...\nCheck spelling."
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
    }

    convenience init(message: String) {
        self.init()
        self.message = message
        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpView() {
        messageLabel.text = message
        addSubview(messageLabel)
    }

    private func setUpConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(40)
            make.left.right.equalToSuperview()
        }
    }
}
