//
//  MockReachability.swift
//  RijksMuseumTests
//
//  Created by BinaryBoy on 3/18/22.
//

import Network
import Foundation
@testable import RijksMuseum

final class MockReachability: Reachability {

    let internetConnectionState: NWPath.Status

    override var isConnected: Bool {
        return internetConnectionState == .satisfied
    }

    init(internetConnectionState: NWPath.Status) {
        self.internetConnectionState  = internetConnectionState
        super.init()
    }
}
