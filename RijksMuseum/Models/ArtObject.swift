//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

struct ArtObject: Decodable {

    let objectNumber: String
	let principalOrFirstMaker: String
	let title: String
    let webImage: WebImage
}
