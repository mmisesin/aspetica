//
//  AppDelegate.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = CalculatorViewController()

        return true
    }

}

