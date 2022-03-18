//
//  DataLoader.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

final class DataLoader {

     func loadJsonData(file: String) -> Data? {

        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }

        return nil
    }
}
