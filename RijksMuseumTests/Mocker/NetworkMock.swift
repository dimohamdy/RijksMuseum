//
//  NetworkMock.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit
@testable import RijksMuseum

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}

final class MockURLSession: URLSessionProtocol {
    var dataTask = MockURLSessionDataTask()

    private let completionHandler: (Data?, URLResponse?, Error?)

    init(completionHandler: (Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.completionHandler.0,
                          self.completionHandler.1,
                          self.completionHandler.2)

        return dataTask
    }

    static func createMockSession(fromJsonFile file: String,
                                  andStatusCode code: Int,
                                  andError error: Error?) -> MockURLSession {

        let data = DataLoader().loadJsonData(file: file)

        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return MockURLSession(completionHandler: (data, response, error))
    }
}
