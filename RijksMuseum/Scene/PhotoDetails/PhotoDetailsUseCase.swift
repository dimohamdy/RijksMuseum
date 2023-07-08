//
//  PhotoDetailsUseCase.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 02/07/2023.
//

import Foundation

protocol PhotoDetailsUseCaseProtocol {
    func artObjectDetails(for id: String) async throws -> ArtObjectDetailsResult
}

class PhotoDetailsUseCase: PhotoDetailsUseCaseProtocol {

    let photosRepository: ArtObjectsRepository

    // internal

    private let reachable: Reachable
    private let logger: LoggerProtocol

    // MARK: Init
    init(photosRepository: ArtObjectsRepository,
         reachable: Reachable = Reachability.shared,
         logger: LoggerProtocol) {

        self.photosRepository = photosRepository

        self.reachable = reachable
        self.logger = logger
    }

    func artObjectDetails(for id: String) async throws -> ArtObjectDetailsResult {
        logger.log("artObjectDetails_id\(id)", level: .info)
        return try await photosRepository.artObjectDetails(for: id)
    }
}
