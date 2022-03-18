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
            return "No result"
        case .noInternetConnection:
            return "No internet connection"
        default:
            return "some thing happen"
        }
    }
}
