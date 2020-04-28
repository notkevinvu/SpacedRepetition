//
//  AppDelegate.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/23/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit
import CoreData

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
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SpacedRepetition")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: add error handling here (initialize empty array of decks?)
                print("Unresolved error \(error), \(error.userInfo)")
                assertionFailure()
            }
        }
        
        return container
    }()
    
    // MARK: - Core Data saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: add error handling in saving
                let nsError = error as NSError
                print("Error saving data - error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
}

