//
//  UIViewLoadingTests.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/21/22.
//

import XCTest
@testable import RijksMuseum

final class UIViewLoadingTests: XCTestCase {
    var view: UIView!
    override func setUp() {
        view = UIView()
    }

    override func tearDown() {
        view = nil
    }

    func test_showLoading() {
        view.showLoadingIndicator()
        XCTAssertNotNil(view.viewWithTag(99) )
        if let activityIndicatorView = view.viewWithTag(9) as? UIActivityIndicatorView {
            XCTAssertTrue(activityIndicatorView.isAnimating)
            XCTAssertFalse(activityIndicatorView.isHidden)
        }
    }

    func test_dismissLoading() {
        view.dismissLoadingIndicator()
        XCTAssertNil(view.viewWithTag(99))
    }
}
