//
//  EmptyPlaceHolderView.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 25/05/2023.
//

import UIKit
import SwiftUI

enum EmptyPlaceHolderType: Equatable {
    case noInternetConnection
    case noResults
    case error(message: String)
}

final class EmptyPlaceHolderView: UIView {

    // Replace Conditional with Polymorphism https://refactoring.guru/replace-conditional-with-polymorphism
    var emptyPlaceHolderType: EmptyPlaceHolderType = .noInternetConnection {
        didSet {
            switch emptyPlaceHolderType {
            case .noInternetConnection:
                titleLabel.text = Strings.noInternetConnectionTitle.localized
                detailsLabel.text = Strings.noInternetConnectionSubtitle.localized
                logoImageView.image = UIImage(named: "refresh")?.withTintColor(.secondarySystemBackground, renderingMode: .alwaysOriginal)
                actionButton.isHidden = false
            case .noResults:
                titleLabel.text = Strings.noPhotosErrorTitle.localized
                detailsLabel.text = Strings.noPhotosErrorSubtitle.localized
                logoImageView.image = UIImage(named: "no-result")?.withTintColor(.secondarySystemBackground, renderingMode: .alwaysOriginal)
                actionButton.isHidden = false
            case .error(let message):
                titleLabel.text = Strings.commonGeneralError.localized
                detailsLabel.text = message
                logoImageView.image = UIImage(named: "refresh")?.withTintColor(.secondarySystemBackground, renderingMode: .alwaysOriginal)
                actionButton.isHidden = false
            }
        }
    }

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.tryAction.localized, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.tag = 1
        button.accessibilityIdentifier = AccessibilityIdentifiers.EmptyPlaceHolderView.actionButtonId
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 120)
        ])
        return button
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        imageView.accessibilityIdentifier = AccessibilityIdentifiers.EmptyPlaceHolderView.logoImageViewId
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailsLabel)
        stackView.setCustomSpacing(30, after: detailsLabel)
        stackView.addArrangedSubview(actionButton)
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 2
        label.accessibilityIdentifier = AccessibilityIdentifiers.EmptyPlaceHolderView.titleLabelId
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 3
        label.accessibilityIdentifier = AccessibilityIdentifiers.EmptyPlaceHolderView.detailsLabelId
        return label
    }()

    var completionBlock: (() -> Void)? {
        didSet {
            actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(contentStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: UIView.padding10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIView.padding10),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIView.padding10)
        ])
    }

    @objc
    private func buttonTapped(sender: UIButton) {
       completionBlock?()
    }
}
