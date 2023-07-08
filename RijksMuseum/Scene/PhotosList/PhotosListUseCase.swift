//
//  PhotosListUseCase.swift
//  PhotosListList
//
//  Created by Dimo Abdelaziz on 26/04/2023.
//

import Foundation

protocol PhotosListUseCaseProtocol {
    func search() async throws -> [ArtObject]
    func loadMoreArtObjects(_ page: Int) async throws -> [ArtObject]

    var page: Int { get }
    var canLoadMore: Bool { get}
    var haveData: Bool { get}
}

class PhotosListUseCase: PhotosListUseCaseProtocol {

    let photosRepository: ArtObjectsRepository

    var page: Int = 0
    var canLoadMore = true
    var haveData: Bool = false

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

    func search() async throws -> [ArtObject] {
        haveData = false
        self.page = 0
        self.canLoadMore = true
        return try await getData()
    }

    func loadMoreArtObjects(_ page: Int) async throws -> [ArtObject] {
        guard reachable.isConnected && (self.page <= page && canLoadMore == true) else {
            throw RijksMuseumError.canNotLoadMore
        }

        self.page = page
        return try await getData()
    }

    private func getData() async throws -> [ArtObject] {

        guard reachable.isConnected else {
            throw RijksMuseumError.noInternetConnection
        }
        canLoadMore = false

        let searchResult = try? await photosRepository.artObjects(page: page)
        guard let artObjects = searchResult?.artObjects, !artObjects.isEmpty else {
            throw RijksMuseumError.noResults
        }
        canLoadMore = true
        haveData = true
        return artObjects
    }
}
