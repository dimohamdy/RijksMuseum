//
//  RijksMuseumError.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import Foundation

enum RijksMuseumError: Error, Equatable {
    case failedConnection
    case wrongURL
    case noResults
    case noInternetConnection
    case runtimeError(String)
    case parseError
    case fileNotFound
    case invalidServerResponse
    case canNotLoadMore

    var localizedDescription: String {
        switch self {
        case .noResults:
            return Strings.noResult.localized
        case .noInternetConnection:
            return Strings.noInternetConnectionTitle.localized
        default:
            return Strings.commonGeneralError.localized
        }
    }
}
