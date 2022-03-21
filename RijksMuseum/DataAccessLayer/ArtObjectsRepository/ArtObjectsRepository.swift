//
//  ArtObjectsRepository.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

protocol ArtObjectsRepository {

    func artObjects(for type: String, page: Int, completion: @escaping (Result< CollectionResult, RijksMuseumError>) -> Void)
    func artObjectDetails(for id: String, completion: @escaping (Result<ArtObjectDetailsResult, RijksMuseumError>) -> Void)
}
