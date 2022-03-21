//
//  PhotoTableViewCell.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell, CellReusable {

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image  = UIImage(named: "place_holder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tag = 1
        return imageView
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    private func setupViews() {

        contentView.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIView.padding10),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIView.padding10),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIView.padding10)
        ])

    }

    func configCell(photoModel: UIModel) {
        photoImageView.download(from: photoModel.photoURL, contentMode: .scaleAspectFit)
    }
}

extension PhotoTableViewCell {
    struct UIModel {
        var photoURL: String
    }
}
