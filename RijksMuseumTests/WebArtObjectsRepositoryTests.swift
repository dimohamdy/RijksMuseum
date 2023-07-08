//
//  WebArtObjectsRepositoryTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/18/22.
//

import XCTest
@testable import RijksMuseum

final class WebArtObjectsRepositoryTests: XCTestCase {
    var webArtObjectsRepository: WebArtObjectsRepository!

    override func setUp() {
        webArtObjectsRepository = WebArtObjectsRepository()
    }

    override func tearDown() {
        webArtObjectsRepository = nil
    }

    func test_GetItems_FromAPI() {
        runAsyncTest { [self] in

            let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data_collection", andStatusCode: 200, andError: nil)
            let mockAPIClient =  APIClient(withSession: mockSession)
            webArtObjectsRepository = WebArtObjectsRepository(client: mockAPIClient)
            // Act: get data from API .
            let result = try await webArtObjectsRepository.artObjects(page: 1)
            // Assert: Verify it's have a data.
            XCTAssertGreaterThan(result.artObjects.count, 0)
            XCTAssertEqual(result.artObjects.count, 10)
        }
    }

    func test_NoResult_FromAPI() {
        runAsyncTest { [self] in

            let mockSession = URLSessionMock.createMockSession(fromJsonFile: "noData_collection", andStatusCode: 200, andError: nil)
            let mockAPIClient =  APIClient(withSession: mockSession)
            webArtObjectsRepository = WebArtObjectsRepository(client: mockAPIClient)
            // Act: get data from API .
            let result = try await webArtObjectsRepository.artObjects(page: 1)
            let artObjects = result.artObjects
            // Assert: Verify it's have a data.
            XCTAssertEqual(artObjects.count, 0)
        }
    }
}
