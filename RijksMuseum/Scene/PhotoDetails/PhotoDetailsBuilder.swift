//
//  PhotoDetailsBuilder.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

struct PhotoDetailsBuilder {

    static func viewController(photo: ArtObject,
                               artObjectsRepository: ArtObjectsRepository = WebArtObjectsRepository(),
                               reachable: Reachable = Reachability.shared) -> PhotoDetailsViewController {
        let logger = ProxyLogger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: PhotoDetailsUseCase.self))
        let photoDetailsUseCase = PhotoDetailsUseCase(photosRepository: artObjectsRepository, reachable: reachable, logger: logger)
        let viewModel = PhotoDetailsViewModel(artObject: photo, photoDetailsUseCase: photoDetailsUseCase)
        let viewController = PhotoDetailsViewController(viewModel: viewModel)
        return viewController
    }
}
