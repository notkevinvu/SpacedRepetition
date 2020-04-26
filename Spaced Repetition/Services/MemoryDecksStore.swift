//
//  DecksMemStore.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

protocol DecksStoreFactory {
    func makeDecksStore() -> DecksStoreProtocol
}


protocol DecksStoreProtocol {
    func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void)
    
    func createDeck() -> Deck
    
    func createCard(forDeckID deckID: UUID, card: Card)
    
    func editCard(forDeckID deckID: UUID, card: Card, forCardID cardID: Int)
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int)
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String)
}


// MARK: - TestDecksStore
final class TestDecksStore: DecksStoreProtocol {
    
    // MARK: - Data
    static let kevinCards: [Card] = [
    Card(frontSide: "Kevin's Birthday", backSide: "Sep 22"),
    Card(frontSide: "Kevin's Height", backSide: "68 in."),
    Card(frontSide: "Kevin's Age", backSide: "23")
    ]
    
    static let scienceCards: [Card] = [
    Card(frontSide: "Chemical formula of glucose", backSide: "C6H12O6"),
    Card(frontSide: "Derivative of Position", backSide: "Velocity"),
    Card(frontSide: "Derivative of Velocity", backSide: "Acceleration")
    ]
    
    static var decks = [
        Deck(nameOfDeck: "Kevin", deckID: UUID(), cards: kevinCards),
        Deck(nameOfDeck: "Science", deckID: UUID(), cards: scienceCards)
    ]
    
    
    // TODO: When switching to a database (userdefaults/core data), use this function
    // to pull info from the database and then store it in the decks array
        func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void) {
            // decks needs to be a static var in order to return this type
            // alternatively, we could just do 'return decks' if we want to pull
            // a non static decks object from this memstore
    //        completion { return decks }
            completion { return type(of: self).decks}
        }
    
    // MARK: - CRUD Operations
    
    func createDeck() -> Deck {
        let newDeck = Deck(nameOfDeck: "Untitled Deck", deckID: UUID(), cards: [Card(frontSide: "Test front 1", backSide: "Test front 1"), Card(frontSide: "Test front 2", backSide: "Test back 2"), Card(frontSide: "Lorem ipsum", backSide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")])
        TestDecksStore.decks.append(newDeck)
        return newDeck
    }
    
    
    func createCard(forDeckID deckID: UUID, card: Card) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards.append(card)
    }
    
    
    func editCard(forDeckID deckID: UUID, card: Card, forCardID cardID: Int) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards[cardID] = card
    }
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].cards.remove(at: cardIndexToDelete)
    }
    
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String) {
        guard let indexOfMatchedDeck = TestDecksStore.decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        TestDecksStore.decks[indexOfMatchedDeck].nameOfDeck = title
    }
}


// MARK: - MemoryDecksStore
final class MemoryDecksStore: DecksStoreProtocol {
    
    // MARK: Properties
    private var decks: [Deck] = []
    
    
    // MARK: CRUD Operations
    func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void) {
        completion { return decks}
    }
    
    
    func createDeck() -> Deck {
        let newDeck = Deck(nameOfDeck: "Untitled Deck", deckID: UUID(), cards: [])
        return newDeck
    }
    
    
    func createCard(forDeckID deckID: UUID, card: Card) {
        guard let indexOfMatchedDeck = decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        decks[indexOfMatchedDeck].cards.append(card)
    }
    
    func editCard(forDeckID deckID: UUID, card: Card, forCardID cardID: Int) {
        // TODO: IMPLEMENT
        guard let indexOfMatchedDeck = decks.firstIndex(where: { $0.deckID == deckID}) else { return }
        
        decks[indexOfMatchedDeck].cards[cardID] = card
    }
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        guard let indexOfMatchedDeck = decks.firstIndex(where: { $0.deckID == deckID }) else { return }
        
        decks[indexOfMatchedDeck].cards.remove(at: cardIndexToDelete)
    }
    
    
    func editDeckTitle(forDeckID deckID: UUID, withNewTitle title: String) {
        guard let indexOfMatchedDeck = decks.firstIndex(where: {$0.deckID == deckID}) else { return }
        
        decks[indexOfMatchedDeck].nameOfDeck = title
    }
}
