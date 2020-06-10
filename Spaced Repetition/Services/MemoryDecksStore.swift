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
    
    
    
    // MARK: CD Methods
    
    func fetchCDDecks() -> [Deck]
    
    func createCDDeck() -> Deck?
    
    
}


// MARK: - TestDecksStore
final class TestDecksStore: DecksStoreProtocol {
    
    typealias Factory = CoreDataManagedContextFactory
    
    var managedContext: NSManagedObjectContext!
    
    init(factory: Factory) {
        self.managedContext = factory.makeManagedContext()
    }
    
    
    // MARK: - Core Data methods
    
    static var cdDecks: [Deck] = []
    
    func fetchCDDecks() -> [Deck] {
        let deckFetchReq = Deck.deckfetchRequest()
        
        // MARK: TODO: add the date sort desc if needed
        /*
         Possibly might not need the date sort, we just need to keep track of
         the order in which we add decks to core data - is it possible to wrap
         all the deck entities into an overarching Decks entity that has no
         attributes and only a single to-many relationship to numerous decks?
         */
        
//        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Deck.dateCreated), ascending: true)
//        deckFetchReq.sortDescriptors = [dateSortDescriptor]
        
        /*
         a sort descriptor for sorting by "index" - as we add decks, we set the added
         deck's deckIndex to the count of the current store (i.e. if there are currently
         0 decks fetched, when we add the first deck, its index will be 0 - the
         second deck will check the fetched decks array and find 1 deck, thus the
         index of the second deck will become 1)
         */
        let deckIndexSortDescriptor = NSSortDescriptor(key: #keyPath(Deck.deckIndex), ascending: true)
        deckFetchReq.sortDescriptors = [deckIndexSortDescriptor]
        
        let asyncFetchReq = NSAsynchronousFetchRequest<Deck>(fetchRequest: deckFetchReq) { (result: NSAsynchronousFetchResult) in
            guard let decks = result.finalResult else { return }
            
            TestDecksStore.cdDecks = decks
        }
        
        do {
            try managedContext.execute(asyncFetchReq)
        } catch let error as NSError {
            assertionFailure("Failed to fetch decks \(#line), \(#file) - error: \(error) with desc \(error.userInfo)")
            return []
        }
        
        return TestDecksStore.cdDecks
    }
    
    
    // create deck for test store makes a pre-populated deck
    func createCDDeck() -> Deck? {
        let card1 = Card(context: managedContext)
        card1.initializeCardWith(frontSideText: "Test front 1 CD", backSideText: "Test back 1 CD", cardID: UUID(), dateCreated: Date())
        
        
        let card2 = Card(context: managedContext)
        card2.initializeCardWith(frontSideText: "Test front 2 CORE DATA", backSideText: "Test back 2 CORE DATA", cardID: UUID(), dateCreated: Date())
        
        
        let card3 = Card(context: managedContext)
        card3.initializeCardWith(frontSideText: "Lorem ipsum", backSideText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", cardID: UUID(), dateCreated: Date())
        
        
        let newDeck = Deck(context: managedContext)
        newDeck.initializeDeckWithValues(name: "Untitled Deck", deckID: UUID(), dateCreated: Date(), deckIndex: TestDecksStore.cdDecks.count, cards: [card1, card2, card3])
        
        
        TestDecksStore.cdDecks.append(newDeck)
        
        do {
            guard managedContext.hasChanges else { return nil }
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Error saving new deck \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return nil
        }
        
        return newDeck
    }
    
    
    func deleteCDDeck(withDeckID deckID: UUID) {
        guard let indexOfDeckToRemove = TestDecksStore.cdDecks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.cdDecks.remove(at: indexOfDeckToRemove)
        managedContext.delete(TestDecksStore.cdDecks[indexOfDeckToRemove])
        
        do {
            guard managedContext.hasChanges else { return }
            try managedContext.save()
            
        } catch let error as NSError {
            assertionFailure("Failed to delete deck \(#line) - \(#file), error: \(error) - \(error.userInfo)")
            return
        }
    }
    
    func createCDCard(forDeckID deckID: UUID, card: CardModel) {
        guard let indexOfMatchedDeck = TestDecksStore.cdDecks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        let cardToAdd = Card(context: managedContext)
        cardToAdd.initializeCardWith(frontSideText: card.frontSideText, backSideText: card.backSideText, cardID: card.cardID, dateCreated: card.dateCreated)
        TestDecksStore.cdDecks[indexOfMatchedDeck].addToCards(cardToAdd)
        
        do {
            guard managedContext.hasChanges else { return }
            try managedContext.save()
            
        } catch let error as NSError {
            assertionFailure("Failed to create card \(#line) - \(#file), error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    
    func editCard(_ card: CardModel) {
        let cardFetchReq = Card.cardFetchRequest()
        cardFetchReq.predicate = NSPredicate(format: "%K == %@", #keyPath(Card.cardID), "\(card.cardID)")
        
        do {
            guard let cardToEdit = try managedContext.fetch(cardFetchReq).first else {
                return
            }
            
            cardToEdit.frontSideText = card.frontSideText
            cardToEdit.backSideText = card.backSideText
            
            guard managedContext.hasChanges else { return }
            try managedContext.save()
            
        } catch let error as NSError {
            assertionFailure("Failed to edit card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    
    func deleteCDCard(forCardID cardID: UUID) {
        let cardToDeleteFetchReq = Card.cardFetchRequest()
        
        cardToDeleteFetchReq.predicate = NSPredicate(format: "%K == %@", #keyPath(Card.cardID), "\(cardID)")
        
        do {
            guard let cardToDelete = try managedContext.fetch(cardToDeleteFetchReq).first else { return }
            
            managedContext.delete(cardToDelete)
            
            try managedContext.save()
            
        } catch let error as NSError {
            assertionFailure("Failed to delete card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    
    func editCDDeckTitle(forDeckID deckID: UUID, withNewTitle title: String) {
        
        guard let indexOfMatchedDeck = TestDecksStore.cdDecks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.cdDecks[indexOfMatchedDeck].name = title
        
        do {
            guard managedContext.hasChanges else { return }
            
            try managedContext.save()
            
        } catch let error as NSError {
            assertionFailure("Failed to edit deck title \(#line), \(#file) - error \(error) with desc: \(error.userInfo)")
            return
        }
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
        let newDeck = NaiveDeck(nameOfDeck: "Untitled Deck", cards: [NaiveCard(frontSide: "Test front 1", backSide: "Test back 1"), NaiveCard(frontSide: "Test front 2", backSide: "Test back 2"), NaiveCard(frontSide: "Lorem ipsum", backSide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")])
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
    
    
    // MARK: - Core Data Methods
    
    static var cdDecks: [Deck] = []
    
    func fetchCDDecks() -> [Deck] {
        
        
        return MemoryDecksStore.cdDecks
    }
    
    func createCDDeck() -> Deck? {
        let deck = Deck(context: managedContext)
        deck.initializeDeckWithValues(name: "Test1", deckID: UUID(), dateCreated: Date(), deckIndex: MemoryDecksStore.cdDecks.count, cards: [])
        
        return deck
    }
    
    
    func deleteCDDecks() {
        
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
