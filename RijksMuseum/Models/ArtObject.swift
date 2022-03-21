//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

// TODO: Use inheritance
struct ArtObject: Decodable {

	let longTitle: String
	let objectNumber: String
	let principalOrFirstMaker: String
	let title: String
    let webImage: WebImage
}
