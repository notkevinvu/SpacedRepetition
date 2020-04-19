//
//  DependencyContainer.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/18/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactor = DecksInteractor1(factory: DependencyContainer())
    }
}

class DecksInteractor1 {
    
    typealias Factory = DecksWorkerFactory
    
    let decksWorker: DecksWorkerProtocol
    
    /*
     the initializer here will be used to inject a dependency container
     that conforms to the DecksWorkerFactory protocol.
     
     Thus, we can then use the factory to create a decksWorker
     without needing to worry about too many dependency injections
     */
    init(factory: Factory) {
        self.decksWorker = factory.makeDecksWorker()
    }
}



// MARK: Dependency Container
final class DependencyContainer {
    lazy var decksWorker: DecksWorkerProtocol = DefaultDecksWorker(factory: self)
    lazy var memoryDecksStore: DecksStoreProtocol1 = MemoryDecksStore()
    lazy var defaultDecksStore: DecksStoreProtocol1 = DefaultDecksStore()
}

extension DependencyContainer: DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol {
        return decksWorker
    }
}

extension DependencyContainer: DecksStoreFactory {
    func makeDecksStore() -> DecksStoreProtocol1 {
        // return memoryDecksStore
        return defaultDecksStore
    }
}


// MARK: Default Decks Worker
final class DefaultDecksWorker {
    typealias Factory = DecksStoreFactory
    
    private let decksStore: DecksStoreProtocol1
    
    init(factory: Factory) {
        decksStore = factory.makeDecksStore()
    }
    
}

extension DefaultDecksWorker: DecksWorkerProtocol {
    func fetchDecks() {
        decksStore.fetchDecks()
        // do stuff
    }
    
    func createDeck() {
        decksStore.createDeck()
    }
    

}


// MARK: DecksWorker Protocol
protocol DecksWorkerProtocol {
    func fetchDecks()
    
    func createDeck()
}


// MARK: DecksWorker Factory - START HERE
/*
 We first define a factory protocol that will enable us to create a decks worker
 which should conform to the DecksWorkerProtocol (we can define this before/after -
 the protocol should have required functions to do whatever work the DecksWorker
 needs to do (like fetching or creating decks)
 
 Once we have both our factory and the protocol (which the object produced by
 the factory should conform to), we can store a lazy decksWorker variable in
 our DependencyContainer
 
 We can then extend the DependencyContainer class in cases where the DependencyContainer
 */
protocol DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol
}


// MARK: DecksStore Protocol
protocol DecksStoreProtocol1 {
    func fetchDecks()
    func createDeck()
}


// MARK: DecksStore Factory - START HERE
protocol DecksStoreFactory {
    func makeDecksStore() -> DecksStoreProtocol1
}


// MARK: Test Factory
protocol TestFactory {
    func makeTest() -> String
}


// MARK: Memory Decks Store
final class MemoryDecksStore {
    
    
}

extension MemoryDecksStore: DecksStoreProtocol1 {
    
    func fetchDecks() {
        
        
    }
    
    func createDeck() {
        
        
    }
    
    
}


// MARK: Default DecksStore
final class DefaultDecksStore {
    
    
}

extension DefaultDecksStore: DecksStoreProtocol1 {
    func fetchDecks() {
        assertionFailure("Not supported yet")
        
    }
    
    func createDeck() {
        assertionFailure("Not supported yet")
    }
}





