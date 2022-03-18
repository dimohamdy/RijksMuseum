//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

struct ArtObject: Decodable {

	let id: String
	let longTitle: String
	let objectNumber: String
	let principalOrFirstMaker: String
	let title: String

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case longTitle = "longTitle"
		case objectNumber = "objectNumber"
		case principalOrFirstMaker = "principalOrFirstMaker"
		case title = "title"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(String.self, forKey: .id)
		longTitle = try values.decode(String.self, forKey: .longTitle)
		objectNumber = try values.decode(String.self, forKey: .objectNumber)
		principalOrFirstMaker = try values.decode(String.self, forKey: .principalOrFirstMaker)
		title = try values.decode(String.self, forKey: .title)
	}
}
