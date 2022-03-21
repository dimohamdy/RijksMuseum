//
//  PhotoTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum

final class PhotoTests: XCTestCase {

    private let artObject = DataLoader().loadJsonData(file: "ArtObject")!

    func testDecoding_whenMissingRequiredKeys_itThrows() throws {
        try ["objectNumber", "principalOrFirstMaker", "title", "webImage"].forEach { key in
            AssertThrowsKeyNotFound(key, decoding: ArtObject.self, from: try artObject.json(deletingKeyPaths: key))
        }
    }

    func testDecoding_whenPhotoData_returnsAPhotoObject() throws {
       let artObject =  try JSONDecoder().decode(ArtObject.self, from: artObject)
        XCTAssertEqual(artObject.objectNumber, "RP-P-1908-5609")
        XCTAssertEqual(artObject.principalOrFirstMaker, "Albert Flamen")
        XCTAssertEqual(artObject.title, "Gezicht op de kerk van Moulineux")
    }

    func AssertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data), file: file, line: line) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.", file: file, line: line)
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)", file: file, line: line)
            }
        }
    }
}

extension Data {
    func json(deletingKeyPaths keyPaths: String...) throws -> Data {
        let decoded = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject

        for keyPath in keyPaths {
            decoded.setValue(nil, forKeyPath: keyPath)
        }

        return try JSONSerialization.data(withJSONObject: decoded)
    }
}
