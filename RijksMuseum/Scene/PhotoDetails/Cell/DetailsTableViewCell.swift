//
//  DetailsTableViewCell.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell, CellReusable {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 2
        return label
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 1.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tag = 3
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    private func setupViews() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)

        contentView.addSubview(titleStackView)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIView.padding10),
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIView.padding10),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIView.padding10)
        ])

    }

    func configCell(photoModel: UIModel) {
        titleLabel.text = photoModel.title
        subtitleLabel.text = photoModel.subTitle
    }
}

extension DetailsTableViewCell {
    struct UIModel {
        var title: String
        var subTitle: String
    }
}
