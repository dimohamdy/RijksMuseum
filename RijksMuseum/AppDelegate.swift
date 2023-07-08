//
//  AppDelegate.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/18/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Reachability.shared.startNetworkReachabilityObserver()
        MemoryMonitor.shared.startMemoryMonitorObserver()
        return true
    }
}
