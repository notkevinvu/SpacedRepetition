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
    func fetchDecks(completion: @escaping ([Deck]) -> Void)
    func createDeck() -> Deck
    func createCard(forDeckID deckID: UUID, card: Card)
    func editCard(forDeckID deckID: UUID, withCard card: Card, forCardID: Int)
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
    func fetchDecks(completion: @escaping ([Deck]) -> Void) {
        decksStore.fetchDecks { (decks: () throws -> [Deck]) -> Void in
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
    
    func createDeck() -> Deck {
        let newDeck = decksStore.createDeck()
        return newDeck
    }
    
    func createCard(forDeckID deckID: UUID, card: Card) {
        decksStore.createCard(forDeckID: deckID, card: card)
    }
    
    func editCard(forDeckID deckID: UUID, withCard card: Card, forCardID cardID: Int) {
        decksStore.editCard(forDeckID: deckID, card: card, forCardID: cardID)
    }
    
    func deleteCard(forDeckID deckID: UUID, cardIndexToDelete: Int) {
        decksStore.deleteCard(forDeckID: deckID, cardIndexToDelete: cardIndexToDelete)
    }
    
    func editTitle(forDeckID deckID: UUID, withNewTitle newTitle: String) {
        decksStore.editDeckTitle(forDeckID: deckID, withNewTitle: newTitle)
    }
}
