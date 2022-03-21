//
//  DetailsArtObject.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import Foundation

struct DetailsArtObject: Decodable {
    let objectNumber: String
    let title: String
    let longTitle: String
    let principalOrFirstMaker: String
    let webImage: WebImage

    let description: String?
    let materials: [String]?
    let techniques: [String]?
    let subTitle: String?

    init(artObject: ArtObject) {
        self.objectNumber = artObject.objectNumber
        self.title = artObject.title
        self.longTitle = artObject.longTitle
        self.principalOrFirstMaker = artObject.principalOrFirstMaker
        self.webImage = artObject.webImage

        self.description = nil
        self.materials = nil
        self.techniques = nil
        self.subTitle = nil
    }
}
