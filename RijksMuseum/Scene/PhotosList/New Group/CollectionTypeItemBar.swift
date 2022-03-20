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
        return label
    }()

    private let selectionTintColor: UIColor = .systemBlue
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
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configCell(collectionType: CollectionType) {
        titleLabel.text = collectionType.rawValue
    }
}
