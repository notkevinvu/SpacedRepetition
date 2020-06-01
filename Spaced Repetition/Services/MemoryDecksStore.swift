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
    
    func fetchDecks(completion: @escaping (() throws -> [NaiveDeck]) -> Void)
    
    func createDeck() -> NaiveDeck
    
    func deleteDeck(forDeckID deckID: UUID)
    
    func createCard(forDeckID deckID: UUID, card: NaiveCard)
    
    func editCard(forDeckID deckID: UUID, card: NaiveCard, forCardID cardID: Int)
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int)
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String)
}


// MARK: - TestDecksStore
final class TestDecksStore: DecksStoreProtocol {
    
    typealias Factory = CoreDataManagedContextFactory
    
    var managedContext: NSManagedObjectContext!
    
    init(factory: Factory) {
        self.managedContext = factory.makeManagedContext()
    }
    
    // MARK: - Data
    static let kevinCards: [NaiveCard] = [
    NaiveCard(frontSide: "Kevin's Birthday", backSide: "Sep 22"),
    NaiveCard(frontSide: "Kevin's Height", backSide: "68 in."),
    NaiveCard(frontSide: "Kevin's Age", backSide: "23")
    ]
    
    static let scienceCards: [NaiveCard] = [
    NaiveCard(frontSide: "Chemical formula of glucose", backSide: "C6H12O6"),
    NaiveCard(frontSide: "Derivative of Position", backSide: "Velocity"),
    NaiveCard(frontSide: "Derivative of Velocity", backSide: "Acceleration")
    ]
    
    static var decks: [NaiveDeck] = []
    
    static let decksStoreIdentifier = "Decks"
    
    
    // TODO: When switching to a database (userdefaults/core data), use this function
    // to pull info from the database and then store it in the decks array
    func fetchDecks(completion: @escaping (() throws -> [NaiveDeck]) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            if TestDecksStore.decks.isEmpty {
                TestDecksStore.decks = [
                    NaiveDeck(nameOfDeck: "Kevin", cards: TestDecksStore.kevinCards),
                    NaiveDeck(nameOfDeck: "Science", cards: TestDecksStore.scienceCards)
                ]
            }
            
            let defaults = UserDefaults.standard
            guard let savedDecks = defaults.object(forKey: TestDecksStore.decksStoreIdentifier) as? Data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                TestDecksStore.decks = try jsonDecoder.decode([NaiveDeck].self, from: savedDecks)
            } catch {
                print("Error loading data from userdefaults")
            }
        }
        
        DispatchQueue.main.async {
            // decks needs to be a static var in order to return this type
                    // alternatively, we could just do 'return decks' if we want to pull
                    // a non static decks object from this memstore
            //        completion { return decks }
            completion { return type(of: self).decks }
        }
        
    }
    
    // MARK: - CRUD Operations
    
    func createDeck() -> NaiveDeck {
        let newDeck = NaiveDeck(nameOfDeck: "Untitled Deck", cards: [NaiveCard(frontSide: "Test front 1", backSide: "Test front 1"), NaiveCard(frontSide: "Test front 2", backSide: "Test back 2"), NaiveCard(frontSide: "Lorem ipsum", backSide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")])
        TestDecksStore.decks.append(newDeck)
        saveDecksData()
        return newDeck
    }
    
    
    func deleteDeck(forDeckID deckID: UUID) {
        guard let indexOfMatchedDeck = type(of: self).decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        type(of: self).decks.remove(at: indexOfMatchedDeck)
        saveDecksData()
    }
    
    
    func createCard(forDeckID deckID: UUID, card: NaiveCard) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards.append(card)
        saveDecksData()
    }
    
    
    func editCard(forDeckID deckID: UUID, card: NaiveCard, forCardID cardID: Int) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards[cardID] = card
        saveDecksData()
    }
    
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards.remove(at: cardIndexToDelete)
        saveDecksData()
    }
    
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].nameOfDeck = title
        saveDecksData()
    }
    
    
    // save the current snapshot of the desired encodable value (TestDecksStore.decks in this case)
    /**
     Saves the current snapshot of the Decks store's deck array.
     
     Call this whenever you update or change any deck object:
     * Adding a deck
     * Updating deck title
     * Adding a card
     * Updating a card (i.e. editing the card or deleting the card)
     */
    func saveDecksData() {
        let jsonEncoder = JSONEncoder()
        guard let savedData = try? jsonEncoder.encode(TestDecksStore.decks) else { return }
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: TestDecksStore.decksStoreIdentifier)
    }
}


// MARK: - MemoryDecksStore
final class MemoryDecksStore: DecksStoreProtocol {
    
    typealias Factory = CoreDataManagedContextFactory
    
    var managedContext: NSManagedObjectContext!
    
    init(factory: Factory) {
        self.managedContext = factory.makeManagedContext()
    }
    
    // MARK: Properties
    // singleton decks variable to access the same decks array from any scene
    // otherwise, the decks worker's decks store would be different from scene
    // to scene 
    static var decks: [NaiveDeck] = []
    
    
    // MARK: CRUD Operations
    func fetchDecks(completion: @escaping (() throws -> [NaiveDeck]) -> Void) {
        completion { return MemoryDecksStore.decks}
    }
    
    
    func createDeck() -> NaiveDeck {
        let newDeck = NaiveDeck(nameOfDeck: "Untitled Deck", cards: [])
        
        MemoryDecksStore.decks.append(newDeck)
        return newDeck
    }
    
    
    func deleteDeck(forDeckID deckID: UUID) {
        guard let indexOfMatchedDeck = type(of: self).decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        type(of: self).decks.remove(at: indexOfMatchedDeck)
        saveDecksData()
    }
    
    
    func createCard(forDeckID deckID: UUID, card: NaiveCard) {
        guard let indexOfMatchedDeck = MemoryDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        MemoryDecksStore.decks[indexOfMatchedDeck].cards.append(card)
        print("added card")
    }
    
    func editCard(forDeckID deckID: UUID, card: NaiveCard, forCardID cardID: Int) {
        // TODO: IMPLEMENT
        guard let indexOfMatchedDeck = MemoryDecksStore.decks.firstIndex(where: { $0.deckID == deckID}) else { return }
        
        MemoryDecksStore.decks[indexOfMatchedDeck].cards[cardID] = card
    }
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        guard let indexOfMatchedDeck = MemoryDecksStore.decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        MemoryDecksStore.decks[indexOfMatchedDeck].cards.remove(at: cardIndexToDelete)
    }
    
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String) {
        guard let indexOfMatchedDeck = MemoryDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        MemoryDecksStore.decks[indexOfMatchedDeck].nameOfDeck = title
    }
    
    func saveDecksData() {
        let jsonEncoder = JSONEncoder()
        guard let savedData = try? jsonEncoder.encode(TestDecksStore.decks) else { return }
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: TestDecksStore.decksStoreIdentifier)
    }
}
