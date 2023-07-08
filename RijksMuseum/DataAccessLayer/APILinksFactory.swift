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

    static let apiKey: String = "0fiuZFh4"

    private static var baseURL: String {
        if ProcessInfo.processInfo.arguments.contains("UITesting") {
            return "http://localhost:4561/api/en/collection"
        } else {
            return "https://www.rijksmuseum.nl/api/en/collection"
        }
    }

    enum API {

        case search(type: String, perPage: Int, page: Int)
        case details(artObjectId: String)

        var url: URL? {
            switch self {
            case .search(let type, let perPage, let page):
                return generateAPIURLForCollection(apiKey: apiKey, type: type, perPage: perPage, page: page)
            case .details(let artObjectId):
                return generateAPIURLForArtDetails(apiKey: apiKey, artObjectId: artObjectId)
            }
        }

        func generateAPIURLForCollection(apiKey: String, type: String, perPage: Int, page: Int) -> URL? {
            var components = URLComponents(string: APILinksFactory.baseURL)
            let queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "imgonly", value: "true"),
                URLQueryItem(name: "type", value: type),
                URLQueryItem(name: "ps", value: String(perPage)),
                URLQueryItem(name: "p", value: String(page))
            ]

            components?.queryItems = queryItems
            return components?.url
        }

        func generateAPIURLForArtDetails(apiKey: String, artObjectId: String) -> URL? {
            let urlString = APILinksFactory.baseURL + "/\(artObjectId)"
            var components = URLComponents(string: urlString)
            let queryItem = URLQueryItem(name: "key", value: apiKey)
            components?.queryItems = [queryItem]
            return components?.url
        }

    }
}
