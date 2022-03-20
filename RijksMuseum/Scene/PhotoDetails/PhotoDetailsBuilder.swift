//
//  PhotoDetailsBuilder.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

struct PhotoDetailsBuilder {

    static func viewController(photo: ArtObject) -> UIViewController {
        let presenter = PhotoDetailsPresenter(artObject: photo)
        let viewController = PhotoDetailsViewController(presenter: presenter)
        presenter.photoDetailsPresenterOutput = viewController
        return viewController
    }
}
