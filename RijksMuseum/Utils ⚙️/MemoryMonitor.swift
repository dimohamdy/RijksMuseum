//
//  MemoryMonitor.swift
//  RijksMuseum
//
//  Created by Dimo Abdelaziz on 30/05/2023.
//

import UIKit
import Kingfisher

struct MemoryMonitor {

    static let shared = MemoryMonitor()

    private init() {

    }

    func startMemoryMonitorObserver() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { _ in
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }
}
