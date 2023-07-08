//
//  WebArtObjectsRepository.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

final class WebArtObjectsRepository: ArtObjectsRepository {

    let client: APIClient
    init(client: APIClient = APIClient()) {
        self.client =  client
    }

    func artObjects(page: Int) async throws -> ArtObjectCollectionResult {
        guard let encodedText = "painting".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            throw RijksMuseumError.wrongURL
        }
        guard let url = APILinksFactory.API.search(type: encodedText, perPage: Constant.pageSize, page: page).url else {
            throw RijksMuseumError.wrongURL
        }
        return try await client.loadData(from: url)
    }

    func artObjectDetails(for artObjectId: String) async throws -> ArtObjectDetailsResult {
        guard let url = APILinksFactory.API.details(artObjectId: artObjectId).url else {
            throw RijksMuseumError.wrongURL
        }
        return try await client.loadData(from: url)
    }
}
