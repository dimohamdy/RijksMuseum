//
//  CollectionTypeItemBar.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/19/22.
//

import UIKit

final class CollectionTypeItemBar: UICollectionViewCell, CellReusable {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let selectedLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 2)
        ])
        view.tag = 2
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        return view
    }()


    private let selectionTintColor: UIColor = .systemYellow
    private let  defaultTintColor: UIColor = .clear

    private let selectionLabelColor: UIColor = .label
    private let defaultLabelColor: UIColor = .secondaryLabel

    private var isSelected_: Bool = false
    override var isSelected: Bool {
        get {
            return isSelected_
        }

        set {
            isSelected_ = newValue
            titleLabel.textColor = newValue ? selectionLabelColor : defaultLabelColor
            selectedLine.backgroundColor = newValue ? selectionTintColor : defaultTintColor
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(selectedLine)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIView.padding10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIView.padding10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            selectedLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIView.padding10),
            selectedLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIView.padding10),
            selectedLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }

    func configCell(collectionType: CollectionType) {
        titleLabel.text = collectionType.rawValue.capitalized
    }
}
