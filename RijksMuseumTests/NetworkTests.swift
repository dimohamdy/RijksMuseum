//
//  NetworkTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/18/22.
//


import XCTest
@testable import RijksMuseum

final class NetworkTests: XCTestCase {
    
    func test_GetItems_Success() throws {

        let mockAPIClient =  getMockAPIClient(fromJsonFile: "data")
        loadData(mockAPIClient: mockAPIClient) { (result: Result<CollectionResult, RijksMuseumError>) in
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.artObjects.count, 0)
            default:
                XCTFail("Can't get Data")
            }
        }
    }

    func test_NotGetData_Fail() throws {
        let mockAPIClient =  getMockAPIClient(fromJsonFile: "noData")
        loadData(mockAPIClient: mockAPIClient) { (result: Result<CollectionResult, RijksMuseumError>) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.artObjects.count, 0)
            default:
                XCTFail("Can't get Data")
            }
        }
    }

    private func getMockAPIClient(fromJsonFile file: String) -> APIClient {
        let mockSession = MockURLSession.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        return APIClient(withSession: mockSession)
    }

    private func loadData<T: Decodable>(mockAPIClient: APIClient, completion: @escaping (Result<T, RijksMuseumError>) -> Void) {
        let path = APILinksFactory.API.search(type: "Car", perPage: 10, page: 1).path
        guard let url = URL(string: path) else {
            return
        }
        mockAPIClient.loadData(from: url, completion: completion)
    }
}
