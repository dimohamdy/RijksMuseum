//
//  ArtObjectsRepository.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

protocol ArtObjectsRepository {

    func artObjects(page: Int) async throws -> ArtObjectCollectionResult
    func artObjectDetails(for id: String) async throws -> ArtObjectDetailsResult
}
