//
//  DependencyContainer.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/18/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

// MARK: Dependency Container
final class DependencyContainer {
    // when we initialize the decksWorker here, we activate the init, which also
    // creates a decksStore for the decksWorker
    lazy var decksWorker: DecksWorkerProtocol = DecksWorker(factory: self)
    lazy var testDecksStore: DecksStoreProtocol = TestDecksStore()
    lazy var memoryDecksStore: DecksStoreProtocol = MemoryDecksStore()
}

extension DependencyContainer: DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol {
        return decksWorker
    }
}

extension DependencyContainer: DecksStoreFactory {
    func makeDecksStore() -> DecksStoreProtocol {
        // TODO: switch from testDecksStore to memoryDecksStore when core data
        // saving is implemented
         return testDecksStore
//        return memoryDecksStore
    }
}













// MARK: Start skeleton - Ignore
/*
 
final class DecksWorker9 {
    private let decksStore: DecksStoreProtocol9
    
    init(factory: DecksStoreFactory9) {
        self.decksStore = factory.makeDecksStore()
    }
}

// MARK: Default Decks Worker
final class DefaultDecksWorker {
    typealias Factory = DecksStoreFactory9
    
    private let decksStore: DecksStoreProtocol9
    
    init(factory: Factory) {
        decksStore = factory.makeDecksStore()
    }
    
}

extension DefaultDecksWorker: DecksWorkerProtocol9 {
    func fetchDecks() {
        decksStore.fetchDecks()
        // do stuff
    }
    
    func createDeck() {
        decksStore.createDeck()
    }
    

}


// MARK: DecksWorker Protocol
protocol DecksWorkerProtocol9 {
    func fetchDecks()
    
    func createDeck()
}


// MARK: DecksWorker Factory - START HERE
/*
 In regards to a DecksWorker, we first define a DecksWorker protocol and fill it
 with whatever methods we require (or save that for later - doesn't matter).
 
 Then, we define a factory protocol that contains a method to create a decksWorker
 (something like 'func makeDecksWorker() -> DecksWorkerProtocol')
 
 Once we have both our factory and the protocol (which the object produced by
 the factory should conform to), we can store a lazy decksWorker variable in
 our DependencyContainer
 
 We can then extend the DependencyContainer class to provide default
 implementations of factory methods. Thus, when we initialize something that
 requires a worker or memory store, we can inject the DependencyContainer
 and the DependencyContainer should automatically create a worker/memory store
 (depending on what you injected it into)
 
 MARK: Example
 
 If an interactor needs to use a worker to do some specialized work,
 we can set up the interactor like so:
 
 final class DecksInteractor {
    typealias Factory = DecksWorkerFactory
    let decksWorker: DecksWorkerProtocol
    
    init(factory: Factory) {
        self.decksWorker = factory.makeDecksWorker()
    }
 }
 
 Then, we can provide an extension of the DependencyContainer class that conforms
 to the DecksWorkerFactory protocol
 
 extension DependencyContainer: DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol {
        return decksWorker
    }
 }
 
 Thus, when we inject the dependency container into the interactor like so:
 
 class ViewController: UIViewController {
    ...
    let interactor = DecksInteractor(factory: DependencyContainer())
 }
 
 It should initialize an Interactor with a working DecksWorker, but by a form of
 dependency injection within the ViewController
 
 */

/*
// MARK: Layering dependencies
 
 We can layer the usage of the dependency container as well. For example,
 our DecksWorker also needs to utilize a Decks data store. Thus, we can
 provide an init for the DecksWorker that also takes in a factory (though this
 factory is of a different type [DecksStoreFactory]).
 
 We specified before in the DependencyContainer that the lazy decksWorker var
 will be an instance of the DefaultDecksWorker() class, and since we
 provide an init for the DecksWorker that takes in a factory (and set it to self -
 the dependency container), when we finally initialize the DefaultDecksWorker class,
 it also creates the decksStore variable within the DecksWorker
 
 This allows us to inject either the default/test decks store
 or the actual decks store to use
 
 However, remember to change the dependency container extension
 that corresponds to the protocol we need (i.e. the dependency container extension
 for a decks store factory) to return the actual decks store to use
 when we are finished testing
 
 */

protocol DecksWorkerFactory9 {
    func makeDecksWorker() -> DecksWorkerProtocol9
}


// MARK: DecksStore Protocol
protocol DecksStoreProtocol9 {
    func fetchDecks()
    func createDeck()
}


// MARK: DecksStore Factory - START HERE
protocol DecksStoreFactory9 {
    func makeDecksStore() -> DecksStoreProtocol9
}


// MARK: Test Factory
protocol TestFactory9 {
    func makeTest() -> String
}


// MARK: Memory Decks Store
final class MemoryDecksStore9 {
    
    
}

extension MemoryDecksStore9: DecksStoreProtocol9 {
    
    func fetchDecks() {
        
        
    }
    
    func createDeck() {
        
        
    }
    
    
}


// MARK: Default DecksStore
final class DefaultDecksStore9 {
    
    
}

extension DefaultDecksStore9: DecksStoreProtocol9 {
    func fetchDecks() {
        assertionFailure("Not supported yet")
        
    }
    
    func createDeck() {
        assertionFailure("Not supported yet")
    }
}

*/



