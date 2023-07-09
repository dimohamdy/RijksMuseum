//
//  MockReachability.swift
//  RijksMuseumTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
import Network
import Combine
@testable import RijksMuseum

final class MockReachability: Reachable {

    lazy var isConnected: CurrentValueSubject<Bool, Never> = .init(internetConnectionState == .satisfied)

    let internetConnectionState: NWPath.Status

    init(internetConnectionState: NWPath.Status) {
        self.internetConnectionState = internetConnectionState
    }

    func startNetworkReachabilityObserver() {

    }
}
