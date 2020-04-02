//
//  AppDelegate.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/23/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navController = UINavigationController()
        let vc = DecksViewController()
        
        navController.viewControllers = [vc]
        window?.rootViewController = navController
        
        return true
    }

}

