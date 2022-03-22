//
//  APILinksFactory.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

struct APILinksFactory {

    #warning("Replace your API Key in API_KEY ")
    #warning("I used to use Cocoakeys to save secret keys")

    static let apiKey: String = "API_KEY"
    private static let baseURL = "https://www.rijksmuseum.nl/api/en/collection"

    enum API {
        case search(type: String, perPage: Int, page: Int)
        case details(artObjectId: String)

        var path: String {
            switch self {
            case .search(let type, let perPage, let page):
                return APILinksFactory.baseURL + "?key=\(apiKey)&imgonly=true&type=\(type)&ps=\(perPage)&p=\(page)"
            case .details(let artObjectId):
                return APILinksFactory.baseURL + "/\(artObjectId)?key=\(apiKey)"
            }
        }

    }
}
