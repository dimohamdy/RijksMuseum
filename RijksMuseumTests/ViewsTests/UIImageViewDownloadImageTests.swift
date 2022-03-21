//
//  UIImageViewDownloadImageTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum
import Kingfisher

final class UIImageViewDownloadImageTests: XCTestCase {

    var imageView: UIImageView!

    override func setUp() {
        imageView = UIImageView()
    }

    override func tearDown() {
        KingfisherManager.shared.cache.clearCache()
        imageView.kf.cancelDownloadTask()
        imageView = nil
    }

    func test_downloadImage() {
        let expectation = XCTestExpectation()

        XCTAssertNil(imageView.image)
        imageView.download(from: "https://lh5.ggpht.com/cCbXCT492kqBYGCrK1pvdJ-nGIGzXluy6po3w0UzL8vLl6OR-MYhUcXOZGlfJW-7GFflBuQewQnDbKYxyEFKi-fN1Hk=s0")
        XCTAssertNotNil(imageView.image, "imageView have placeholder")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotEqual(UIImage(named: "place_holder"), self.imageView.image, "imageView have the downloaded image")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6)
    }

    func test_cancelDownloadImage() {
        imageView.download(from: "https://lh5.ggpht.com/cCbXCT492kqBYGCrK1pvdJ-nGIGzXluy6po3w0UzL8vLl6OR-MYhUcXOZGlfJW-7GFflBuQewQnDbKYxyEFKi-fN1Hk=s0")
        XCTAssertNotNil( imageView.kf.taskIdentifier)
        imageView.kf.cancelDownloadTask()
        XCTAssertNil(imageView.kf.taskIdentifier)
        XCTAssertEqual(UIImage(named: "place_holder"), imageView.image, "imageView have only placeholder")

    }
}
