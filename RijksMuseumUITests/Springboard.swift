//
//  Springboard.swift
//  RijksMuseumUITests
//
//  Created by Dimo Abdelaziz on 09/07/2023.
//

import Foundation
import XCTest

final class Springboard {

    private static var springboardApp = XCUIApplication(bundleIdentifier: "dimo.hamdy.RijksMuseum")

    class func deleteApp(name: String) {
        XCUIApplication().terminate()

        springboardApp.activate()

        sleep(1)

        let appIcon = springboardApp.icons.matching(identifier: name).firstMatch
        appIcon.press(forDuration: 1.3)

        sleep(1)

        springboardApp.buttons["Delete App"].tap()

        let deleteButton = springboardApp.alerts.buttons["Delete"].firstMatch
        if deleteButton.waitForExistence(timeout: 5) {
            deleteButton.tap()
        }
    }
}
