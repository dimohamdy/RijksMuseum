//
//  MockDataPhotosRepository.swift
//  PhotosTests
//
//  Created by Dimo Abdelaziz on 13/03/2023.
//

import Foundation
@testable import RijksMuseum

final class MockDataPhotosRepository: ArtObjectsRepository {

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    func artObjects(page: Int) async throws -> RijksMuseum.ArtObjectCollectionResult {
        guard let data = DataLoader().loadJsonData(file: "data_collection") else {
            throw RijksMuseumError.noResults
        }
        let result = try decoder.decode(ArtObjectCollectionResult.self, from: data)
        return result
    }

    func artObjectDetails(for id: String) async throws -> RijksMuseum.ArtObjectDetailsResult {
        guard let data = DataLoader().loadJsonData(file: "ArtObjectDetailsResult") else {
            throw RijksMuseumError.noResults
        }
        let artObjectDetailsResult = try decoder.decode(ArtObjectDetailsResult.self, from: data)
        return artObjectDetailsResult
    }

}
