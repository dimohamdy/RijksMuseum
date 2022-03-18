//
//  CollectionResult.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

struct CollectionResult: Decodable {

    let artObjects: [ArtObject]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case artObjects
        case count
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artObjects = try values.decode([ArtObject].self, forKey: .artObjects)
        count = try values.decode(Int.self, forKey: .count)
    }
}
