//
//  Reachability.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 25/05/2023.
//

import Foundation
import Network
import Combine

protocol Reachable {
    var isConnected: Bool { get }
    func startNetworkReachabilityObserver()
}

class Reachability: Reachable {

    private var cancellables = Set<AnyCancellable>()
     private let monitorQueue = DispatchQueue(label: "monitor")

     @Published var networkStatus: NWPath.Status = .satisfied
     @Published var isConnectedPublisher: Bool = true

    static let shared = Reachability()
    private let monitor = NWPathMonitor()

    private init() {

    }

    var isConnected: Bool {
        networkStatus == .satisfied
    }

    func startNetworkReachabilityObserver() {
        NWPathMonitor()
             .publisher(queue: monitorQueue)
             .receive(on: DispatchQueue.main)
             .sink { [weak self] status in
                 self?.networkStatus = status
             }
             .store(in: &cancellables)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                NotificationCenter.default.post(name: Notifications.Reachability.connected.name, object: nil)
            } else if path.status == .unsatisfied {
                NotificationCenter.default.post(name: Notifications.Reachability.notConnected.name, object: nil)
            }
        }
        monitor.start(queue: .main)
    }
}
