//
//  XCTestCase+AsyncTest.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 10/23/22.
//

import XCTest
import Combine

extension XCTestCase {
    func runAsyncTest(
        named testName: String = #function,
        in file: StaticString = #file,
        at line: UInt = #line,
        withTimeout timeout: TimeInterval = 10,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        if let error = thrownError {
            XCTFail(
                "Async error thrown: \(error)",
                file: file,
                line: line
            )
        }
    }
}

//extension XCTestCase {
//    func awaitPublisher<T: Publisher>(
//        _ publisher: T,
//        timeout: TimeInterval = 10,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) throws -> T.Output {
//        // This time, we use Swift's Result type to keep track
//        // of the result of our Combine pipeline:
//        var result: Result<T.Output, Error>?
//        let expectation = self.expectation(description: "Awaiting publisher")
//
//        let cancellable = publisher.sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    result = .failure(error)
//                case .finished:
//                    break
//                }
//
//                expectation.fulfill()
//            },
//            receiveValue: { value in
//                result = .success(value)
//            }
//        )
//
//        // Just like before, we await the expectation that we
//        // created at the top of our test, and once done, we
//        // also cancel our cancellable to avoid getting any
//        // unused variable warnings:
//        waitForExpectations(timeout: timeout)
//        cancellable.cancel()
//
//        // Here we pass the original file and line number that
//        // our utility was called at, to tell XCTest to report
//        // any encountered errors at that original call site:
//        let unwrappedResult = try XCTUnwrap(
//            result,
//            "Awaited publisher did not produce any output",
//            file: file,
//            line: line
//        )
//
//        return try unwrappedResult.get()
//    }
//}
