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
    
    static let apiKey: String = "0fiuZFh4"//"API_KEY"
    private static let baseURL = "https://www.rijksmuseum.nl/api/en/collection?key=\(apiKey)&imgonly=true"

    enum API {
        case search(type: String, perPage: Int, page: Int)

        var path: String {
            switch self {
            case .search(let type, let perPage, let page):
                return APILinksFactory.baseURL + "&type=\(type)&ps=\(perPage)&p=\(page)"
            }
        }
    }
}
