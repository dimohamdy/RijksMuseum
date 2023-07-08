//
//  EntryPoint.swift
//  RijksMuseum
//
//  Created by BinaryBoy on 3/20/22.
//

import UIKit

struct EntryPoint {

    func initSplashScreen(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: PhotosListBuilder.viewController())
        window.makeKeyAndVisible()
    }
}
