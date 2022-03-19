//
//  WebImage.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

struct WebImage: Decodable {
    let guid: String
    let url: String
    let width: Int
    let height: Int
}
