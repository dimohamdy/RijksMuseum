//
//  PhotosListBuilder.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

struct PhotosListBuilder {
    
    static func viewController() -> PhotosListViewController {
        let viewController: PhotosListViewController = PhotosListViewController()
        let presenter = PhotosListPresenter(output: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
