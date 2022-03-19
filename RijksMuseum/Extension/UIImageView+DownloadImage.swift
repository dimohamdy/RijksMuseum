//
//  UIImageView+DownloadImage.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit
import Kingfisher

extension UIImageView {

    func download(from path: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: path) else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "place_holder"),
            options: [
                .transition(.fade(0.1)),
                .memoryCacheExpiration(.seconds(200)),
                .diskCacheExpiration(.seconds(200))
            ])
    }
}
