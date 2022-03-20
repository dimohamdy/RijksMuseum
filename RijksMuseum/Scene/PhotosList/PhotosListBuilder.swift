//
//  PhotosListBuilder.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

struct PhotosListBuilder {
    
    static func viewController() -> PhotosListViewController {
        let viewController: PhotosListViewController = PhotosListViewController()
        let presenter = PhotosListPresenter(output: viewController)
        viewController.presenter = presenter


        let router = PhotoListRouter(viewController: viewController)
        presenter.router = router

        return viewController
    }
}
