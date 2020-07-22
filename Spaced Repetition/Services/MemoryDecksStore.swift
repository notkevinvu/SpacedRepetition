//
//  DecksMemStore.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation
import CoreData

protocol DecksStoreFactory {
    func makeDecksStore() -> DecksStoreProtocol
}

protocol CoreDataManagedContextFactory {
    func makeManagedContext() -> NSManagedObjectContext
}


protocol DecksStoreProtocol {
    var managedContext: NSManagedObjectContext! { get set }
    
    func fetchDecks() -> [Deck]
    
    func createDeck() -> Deck?
    
}


// MARK: - TestDecksStore
final class TestDecksStore: DecksStoreProtocol {
    
    typealias Factory = CoreDataManagedContextFactory
    
    var managedContext: NSManagedObjectContext!
    
    init(factory: Factory) {
        self.managedContext = factory.makeManagedContext()
    }
    
    
    // MARK: - Core Data methods
    
    static var decks: [Deck] = []
    
    // MARK: Fetch decks
    func fetchDecks() -> [Deck] {
        let deckFetchReq = Deck.deckFetchRequest()
        
        /*
         a sort descriptor for sorting by "index" - as we add decks, we set the added
         deck's deckIndex to the count of the current store (i.e. if there are currently
         0 decks fetched, when we add the first deck, its index will be 0 - the
         second deck will check the fetched decks array and find 1 deck, thus the
         index of the second deck will become 1)
         */
        let deckIndexSortDescriptor = NSSortDescriptor(key: #keyPath(Deck.deckIndex), ascending: true)
        deckFetchReq.sortDescriptors = [deckIndexSortDescriptor]
        deckFetchReq.fetchBatchSize = 10
        
        let asyncFetchReq = NSAsynchronousFetchRequest<Deck>(fetchRequest: deckFetchReq) { (result: NSAsynchronousFetchResult) in
            guard let decks = result.finalResult else { return }
            
            TestDecksStore.decks = decks
        }
        
        do {
            try managedContext.execute(asyncFetchReq)
        } catch let error as NSError {
            assertionFailure("Failed to fetch decks \(#line), \(#file) - error: \(error) with desc \(error.userInfo)")
            return []
        }
        
        return TestDecksStore.decks
    }
    
    
    // MARK: Create deck
    // create deck for test store makes a pre-populated deck
    func createDeck() -> Deck? {
        let card1 = Card(context: managedContext)
        card1.initializeCardWith(frontSideText: "Test front 1 CD", backSideText: "Test back 1 CD", cardID: UUID(), dateCreated: Date())
        
        
        let card2 = Card(context: managedContext)
        card2.initializeCardWith(frontSideText: "Test front 2 CORE DATA", backSideText: "Test back 2 CORE DATA", cardID: UUID(), dateCreated: Date())
        
        
        let card3 = Card(context: managedContext)
        card3.initializeCardWith(frontSideText: "Lorem ipsum", backSideText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", cardID: UUID(), dateCreated: Date())
        
        
        let newDeck = Deck(context: managedContext)
        newDeck.initializeDeckWithValues(name: "Untitled Deck", deckID: UUID(), dateCreated: Date(), deckIndex: TestDecksStore.decks.count, cards: [card1, card2, card3])
        
        
        TestDecksStore.decks.append(newDeck)
        
        do {
            guard managedContext.hasChanges else { return nil }
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Error saving new deck \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return nil
        }
        
        return newDeck
    }
    
    
}





// MARK: - MemoryDecksStore

final class MemoryDecksStore: DecksStoreProtocol {
    
    typealias Factory = CoreDataManagedContextFactory
    
    var managedContext: NSManagedObjectContext!
    
    init(factory: Factory) {
        self.managedContext = factory.makeManagedContext()
    }
    
    static var decks: [Deck] = []
    
    // MARK: Fetch decks
    func fetchDecks() -> [Deck] {
        let deckFetchReq = Deck.deckFetchRequest()
        
        /*
         a sort descriptor for sorting by "index" - as we add decks, we set the added
         deck's deckIndex to the count of the current store (i.e. if there are currently
         0 decks fetched, when we add the first deck, its index will be 0 - the
         second deck will check the fetched decks array and find 1 deck, thus the
         index of the second deck will become 1)
         */
        let deckIndexSortDescriptor = NSSortDescriptor(key: #keyPath(Deck.deckIndex), ascending: true)
        deckFetchReq.sortDescriptors = [deckIndexSortDescriptor]
        deckFetchReq.fetchBatchSize = 10
        
        let asyncFetchReq = NSAsynchronousFetchRequest<Deck>(fetchRequest: deckFetchReq) { (result: NSAsynchronousFetchResult) in
            guard let decks = result.finalResult else { return }
            
            MemoryDecksStore.decks = decks
        }
        
        do {
            try managedContext.execute(asyncFetchReq)
        } catch let error as NSError {
            assertionFailure("Failed to fetch decks \(#line), \(#file) - error: \(error) with desc \(error.userInfo)")
            return []
        }
        
        return MemoryDecksStore.decks
    }
    
    func createDeck() -> Deck? {
        let deck = Deck(context: managedContext)
        deck.initializeDeckWithValues(name: "Untitled Deck", deckID: UUID(), dateCreated: Date(), deckIndex: MemoryDecksStore.decks.count, cards: [])
        
        return deck
    }
    

}
