//
//  RijksMuseumUITests.swift
//  PhotosUITests
//
//  Created by BinaryBoy on 3/18/22.
//

import XCTest

class RijksMuseumUITests: XCTestCase {

    private var app = XCUIApplication()
    private var server = NativeMockServer()

    override func setUp() {
        XCUIDevice.shared.orientation = .portrait
        server.start()
        app.launchArguments = ["UITesting"]
    }

    /// CLear all things before unit-test
    override func tearDown() {
        XCUIDevice.shared.orientation = .portrait
        server.stop()
        app.launchArguments.removeAll()
    }

    func test_numberOfCells_PhotosListView() throws {
        let response = server.readData(fromFile: "data_collection")
        server.update(collectionResponse: .ok(.json(response)))
        app.launch()

        let collectionView = app.collectionViews[AccessibilityIdentifiers.PhotosListViewController.collectionViewId]

        // Get the list of cells in the table
        let cells = collectionView.cells

        // Check that the number of cells in the list matches the expected number of cells
        XCTAssertGreaterThan(cells.count, 0)
    }

    func test_placeholder_PhotosListView() throws {
        let response = server.readData(fromFile: "noData_collection")
        server.update(collectionResponse: .ok(.json(response)))
        app.launch()

        let titleLabel = app.staticTexts[AccessibilityIdentifiers.EmptyPlaceHolderView.titleLabelId].label
        let detailsLabel = app.staticTexts[AccessibilityIdentifiers.EmptyPlaceHolderView.detailsLabelId].label
        let actionButton = app.buttons[AccessibilityIdentifiers.EmptyPlaceHolderView.actionButtonId].label

        XCTAssertEqual("Please, try again later", detailsLabel)
        XCTAssertEqual("No Photos", titleLabel)
        XCTAssertEqual("Try again", actionButton)
    }

    func test_PhotoDetails() {
        app.launch()

        let collectionView = app.collectionViews[AccessibilityIdentifiers.PhotosListViewController.collectionViewId]
        collectionView.cells["\(AccessibilityIdentifiers.PhotosListViewController.cellId).1"].tap()

        sleep(2)

        let title = app.staticTexts[AccessibilityIdentifiers.PhotoDetailsViewController.titleId].label
        let principalOrFirstMaker = app.staticTexts[AccessibilityIdentifiers.PhotoDetailsViewController.principalOrFirstMakerId].label
        let materials = app.staticTexts[AccessibilityIdentifiers.PhotoDetailsViewController.materialsId].label
        let techniques = app.staticTexts[AccessibilityIdentifiers.PhotoDetailsViewController.techniquesId].label
        let subTitle = app.staticTexts[AccessibilityIdentifiers.PhotoDetailsViewController.subTitleId].label

        XCTAssertEqual("Vanitasstilleven met een schedel met lauwerkrans", title)
        XCTAssertEqual("Hendrick Hondius (I)", principalOrFirstMaker)
        XCTAssertEqual("paper", materials)
        XCTAssertEqual("engraving and letterpress printing", techniques)
        XCTAssertEqual("h 216mm × w 275mm", subTitle)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
