//
//  AppDelegate.swift
//  bouncingview-prototype
//
//  Created by Dmitry Litvinenko on 1/19/20.
//  Copyright © 2020 Dmitry Litvinenko. All rights reserved.
//

import UIKit
import Then
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: UITabBarController!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationVC = UINavigationController(rootViewController: MainViewController()).then {
            $0.tabBarItem.title = "Demo"
            $0.tabBarItem.image = UIImage(named: "demoTabIcon")
        }

        viewController = UITabBarController().then { vc in
            vc.viewControllers = [navigationVC]
            vc.tabBar.isTranslucent = false
        }

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

