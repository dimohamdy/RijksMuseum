//
//  PhotoCollectionCell.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

final class PhotoCollectionCell: UICollectionViewCell, CellReusable {

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image  = UIImage(named: "place_holder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titlesBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        return view
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 1.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
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
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        titlesBackgroundView.addSubview(titleStackView)

        addSubview(photoImageView)
        addSubview(titlesBackgroundView)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: titlesBackgroundView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: titlesBackgroundView.leadingAnchor, constant: UIView.padding10),
            titleStackView.trailingAnchor.constraint(equalTo: titlesBackgroundView.trailingAnchor, constant: -UIView.padding10),
            titleStackView.bottomAnchor.constraint(equalTo: titlesBackgroundView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: titlesBackgroundView.topAnchor)
        ])

        NSLayoutConstraint.activate([
            titlesBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titlesBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titlesBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    func configCell(model: UIModel) {
        photoImageView.download(from: model.imagePath, contentMode: .scaleAspectFit)
        titleLabel.text = model.title
        subtitleLabel.text = model.principalOrFirstMaker
    }
}

extension PhotoCollectionCell {
    struct UIModel {
        let imagePath: String
        let title: String
        let principalOrFirstMaker: String

        init(artObject: ArtObject) {
            self.imagePath = artObject.webImage.url.replacingOccurrences(of: "=s0", with: "=w200")
            self.title = artObject.title
            self.principalOrFirstMaker = artObject.principalOrFirstMaker
        }
    }
}
