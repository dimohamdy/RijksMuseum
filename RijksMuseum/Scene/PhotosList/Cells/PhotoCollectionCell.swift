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
        imageView.tag = 1
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 2
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        label.tag = 2
        return label
    }()

    private let titlesBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70)
        ])
        view.tag = 3
        return view
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 1.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tag = 4
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
            titleStackView.leadingAnchor.constraint(equalTo: titlesBackgroundView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: titlesBackgroundView.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: titlesBackgroundView.bottomAnchor),
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
    }

    func configCell(photo: ArtObject) {
        let imagePath = photo.webImage.url.replacingOccurrences(of: "=s0", with: "=w200")
        photoImageView.download(from: imagePath, contentMode: .scaleAspectFit)

        titleLabel.text = photo.title
        subtitleLabel.text = photo.principalOrFirstMaker
    }
}
