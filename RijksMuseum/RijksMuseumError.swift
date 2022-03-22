//
//  RijksMuseumError.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

enum RijksMuseumError: Error {
    case failedConnection
    case noResults
    case noInternetConnection
    case runtimeError(String)
    case parseError
    case fileNotFound
    case wrongURL

    var localizedDescription: String {
        switch self {
        case .noResults:
            return Strings.noResult.localized()
        case .noInternetConnection:
            return Strings.noInternetConnectionTitle.localized()
        default:
            return Strings.commonGeneralError.localized()
        }
    }
}
