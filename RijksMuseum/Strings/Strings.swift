//
//  Strings.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

enum Strings: String {

    // MARK: Errors
    case commonGeneralError = "Common_GeneralError"
    case commonInternetError = "Common_InternetError"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
