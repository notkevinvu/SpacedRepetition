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
    func fetchDecks(completion: @escaping ([NaiveDeck]) -> Void)
    func createDeck() -> NaiveDeck
    func deleteDeck(forDeckID deckID: UUID)
    func createCard(forDeckID deckID: UUID, card: NaiveCard)
    func editCard(forDeckID deckID: UUID, withCard card: NaiveCard, forCardID: Int)
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int)
    func editTitle(forDeckID deckID: UUID, withNewTitle newTitle: String)
    
    
    
    
    func fetchCDDecks() -> [Deck]
    func createCDDeck() -> Deck?
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
    
    
    // MARK: Core Data stuff
    
    func fetchCDDecks() -> [Deck] {
        let decks = decksStore.fetchCDDecks()
        
        return decks
    }
    
    func createCDDeck() -> Deck? {
        guard let deck = decksStore.createCDDeck() else { return nil }
        
        return deck
    }
    
    
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
    
    
    func deleteCard(card: Card, fromDeck deck: Deck) {
        deck.removeFromCards(card)
        
        do {
            try deck.managedObjectContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to delete card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    
    
    
    
    
    // TODO: REMOVE ALL BELOW
    
    func fetchDecks(completion: @escaping ([NaiveDeck]) -> Void) {
        decksStore.fetchDecks { (decks: () throws -> [NaiveDeck]) -> Void in
            do {
                let decks = try decks()
                DispatchQueue.main.async {
                    // passes out a [Deck] object as the decks variable
                    completion(decks)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func createDeck() -> NaiveDeck {
        let newDeck = decksStore.createDeck()
        return newDeck
    }
    
    func deleteDeck(forDeckID deckID: UUID) {
        decksStore.deleteDeck(forDeckID: deckID)
    }
    
    func createCard(forDeckID deckID: UUID, card: NaiveCard) {
        decksStore.createCard(forDeckID: deckID, card: card)
    }
    
    func editCard(forDeckID deckID: UUID, withCard card: NaiveCard, forCardID cardID: Int) {
        decksStore.editCard(forDeckID: deckID, card: card, forCardID: cardID)
    }
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        decksStore.deleteCard(forDeckID: deckID, cardIndexToDelete: cardIndexToDelete)
    }
    
    func editTitle(forDeckID deckID: UUID, withNewTitle newTitle: String) {
        decksStore.editDeckTitle(forDeckID: deckID, withNewTitle: newTitle)
    }
}
