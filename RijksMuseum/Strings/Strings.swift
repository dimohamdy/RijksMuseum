//
//  Strings.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

enum Strings: String {

    // MARK: Home Screen
    case rijksMuseumTitle = "RijksMuseum_Title"

    // MARK: Errors
    case commonGeneralError = "Common_GeneralError"
    case commonInternetError = "Common_InternetError"

    // MARK: Internet Errors
    case noInternetConnectionTitle = "No_Internet_Connection_Title"
    case noInternetConnectionSubtitle = "No_Internet_Connection_Subtitle"

    // MARK: Photos Errors
    case noPhotosErrorTitle = "No_Photos_Error_Title"
    case noPhotosErrorSubtitle = "No_Photos_Error_Subtitle"

    case tryAction = "Try_Action"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}