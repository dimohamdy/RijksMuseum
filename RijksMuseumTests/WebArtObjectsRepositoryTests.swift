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
        let expectation = XCTestExpectation()

        let mockSession = MockURLSession.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let mockAPIClient =  APIClient(withSession: mockSession)
        webArtObjectsRepository = WebArtObjectsRepository(client: mockAPIClient)
        // Act: get data from API .
        webArtObjectsRepository.artObjects(for: "Car", page: 1) { (result) in
            switch result {
            case .success(let data):
                let artObjects = data.artObjects
                // Assert: Verify it's have a data.
                XCTAssertGreaterThan(artObjects.count, 0)
                XCTAssertEqual(artObjects.count, 10)
                expectation.fulfill()
            default:
                XCTFail("Can't get Data")
            }

        }
        wait(for: [expectation], timeout: 2)
    }

    func test_NoResult_FromAPI() {
        let expectation = XCTestExpectation()

        let mockSession = MockURLSession.createMockSession(fromJsonFile: "noData", andStatusCode: 200, andError: nil)
        let mockAPIClient =  APIClient(withSession: mockSession)
        webArtObjectsRepository = WebArtObjectsRepository(client: mockAPIClient)
        // Act: get data from API .
        webArtObjectsRepository.artObjects(for: "AnyTextToTest", page: 1) { (result) in
            switch result {
            case .success(let data):
                let artObjects = data.artObjects
                // Assert: Verify it's have a data.
                XCTAssertEqual(artObjects.count, 0)
                expectation.fulfill()
            default:
                XCTFail("Can't get Data")
            }

        }
        wait(for: [expectation], timeout: 2)
    }

}
