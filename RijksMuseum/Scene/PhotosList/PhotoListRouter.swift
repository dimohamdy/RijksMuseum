//
//  PhotoListRouter.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

protocol PhotoListRoutable {
    func show(artObject: ArtObject)
}

// MARK: - PhotoListRouter Routable
struct PhotoListRouter: PhotoListRoutable {
    let viewController: UIViewController?
    func show(artObject: ArtObject) {
        let photoDetailsViewController = PhotoDetailsBuilder.viewController(photo: artObject)
        viewController?.navigationController?.pushViewController(photoDetailsViewController, animated: true)
    }
}
