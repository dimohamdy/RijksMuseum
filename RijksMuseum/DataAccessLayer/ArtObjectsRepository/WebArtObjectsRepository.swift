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
    
    func artObjects(for type: String, page: Int, completion: @escaping (Result<CollectionResult, RijksMuseumError>) -> Void) {
        let path = APILinksFactory.API.search(type: type, perPage: Constant.pageSize, page: page).path
        guard let url = URL(string: path) else {
            completion(.failure(.wrongURL))
            return
        }
        client.loadData(from: url) { (result: Result<CollectionResult, RijksMuseumError>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
