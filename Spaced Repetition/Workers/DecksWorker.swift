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
