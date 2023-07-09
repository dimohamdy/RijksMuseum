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
    var isConnected: CurrentValueSubject<Bool, Never> { get }
    func startNetworkReachabilityObserver()
}

class Reachability: Reachable {
    lazy var isConnected: CurrentValueSubject<Bool, Never> = .init(networkStatus == .satisfied)

    private var cancellables = Set<AnyCancellable>()
     private let monitorQueue = DispatchQueue(label: "monitor")

     @Published var networkStatus: NWPath.Status = .satisfied

    static let shared = Reachability()
    private let monitor = NWPathMonitor()

    private init() {

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
