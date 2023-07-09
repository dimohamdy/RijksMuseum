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
        imageView.download(from: "https://picsum.photos/200/300?grayscale")
        XCTAssertNotNil(imageView.image, "imageView have placeholder")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotEqual(UIImage(named: "place_holder"), self.imageView.image, "imageView have the downloaded image")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func test_cancelDownloadImage() {
        imageView.download(from: "https://picsum.photos/200")
        XCTAssertNotNil( imageView.kf.taskIdentifier)
        imageView.kf.cancelDownloadTask()
        XCTAssertNil(imageView.kf.taskIdentifier)
        XCTAssertEqual(UIImage(named: "place_holder"), imageView.image, "imageView have only placeholder")

    }
}
