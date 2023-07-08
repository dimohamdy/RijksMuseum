//
//  PhotosListBuilder.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

struct PhotosListBuilder {

    static func viewController(artObjectsRepository: ArtObjectsRepository = WebArtObjectsRepository(), reachable: Reachable = Reachability.shared) -> PhotosListViewController {
        let logger = ProxyLogger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: PhotosListUseCase.self))
        let photosRepository = artObjectsRepository
        let photosListUseCase = PhotosListUseCase(photosRepository: photosRepository, reachable: reachable, logger: logger)
        let viewModel = PhotosListViewModel(photosListUseCase: photosListUseCase)

        let viewController: PhotosListViewController = PhotosListViewController(viewModel: viewModel)

        let router = PhotoListRouter(viewController: viewController)
        viewModel.router = router

        return viewController
    }
}
