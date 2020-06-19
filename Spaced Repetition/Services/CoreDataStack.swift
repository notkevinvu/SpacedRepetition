//
//  CoreDataStack.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 5/31/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        // MARK: TODO: REMOVE IN MEMORY STORE TYPE AFTER TESTING
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: self.modelName)
        // TODO: Also remove this
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        
        container.loadPersistentStores { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error when loading persistent store at line \(#line) in file \(#file) - error: \(error), userInfo: \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    // this managed context is the only entry point required to access the rest
    // of the stack
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error on line \(#line) in file \(#file) - error: \(error)")
        }
    }
}
