//
//  DecksWorker.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

protocol DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol
}


protocol DecksWorkerProtocol {
    func fetchDecks() -> [Deck]
    func createDeck() -> Deck?
    func editDeckTitle(forDeck deck: Deck, withNewTitle newTitle: String)
    func deleteDeck(deck: Deck)
    func createCard(withCardModel cardModel: CardModel, forDeck deck: Deck)
    func editCard(cardToEdit card: Card, newFrontText: String, newBackText: String)
    func deleteCard(card: Card, fromDeck deck: Deck)
}


final class DecksWorker {
    typealias Factory = DecksStoreFactory
    
    private let decksStore: DecksStoreProtocol
    
    init(factory: Factory) {
        self.decksStore = factory.makeDecksStore()
    }
}

// MARK: - DecksWorker protocol methods
extension DecksWorker: DecksWorkerProtocol {
    
    
    // MARK: - Fetch decks
    func fetchDecks() -> [Deck] {
        let decks = decksStore.fetchDecks()
        
        return decks
    }
    
    // MARK: - Create deck
    func createDeck() -> Deck? {
        guard let deck = decksStore.createDeck() else { return nil }
        
        return deck
    }
    
    // MARK: - Edit deck title
    func editDeckTitle(forDeck deck: Deck, withNewTitle newTitle: String) {
        deck.name = newTitle
        
        guard let managedContext = deck.managedObjectContext else {
            assertionFailure("Failed to get managed context \(#line), \(#file)")
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to save new deck title - \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Delete deck
    func deleteDeck(deck: Deck) {
        
        guard let managedContext = deck.managedObjectContext else {
            assertionFailure("Failed to get managed context \(#line), \(#file)")
            return
        }
        
        managedContext.delete(deck)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to delete deck and save - \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Create card
    func createCard(withCardModel cardModel: CardModel, forDeck deck: Deck) {
        guard let managedContext = deck.managedObjectContext else { return }
        
        let cardToCreate = Card(context: managedContext)
        cardToCreate.initializeCardWith(frontSideText: cardModel.frontSideText, backSideText: cardModel.backSideText, cardID: cardModel.cardID, dateCreated: cardModel.dateCreated)
        
        deck.addToCards(cardToCreate)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to create and save new card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Edit card
    func editCard(cardToEdit card: Card, newFrontText: String, newBackText: String) {
        card.frontSideText = newFrontText
        card.backSideText = newBackText
        
        do {
            try card.managedObjectContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to edit and save card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Delete card
    func deleteCard(card: Card, fromDeck deck: Deck) {
        deck.removeFromCards(card)
        
        do {
            try deck.managedObjectContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to delete card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
}
