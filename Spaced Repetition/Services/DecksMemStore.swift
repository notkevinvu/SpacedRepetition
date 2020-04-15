//
//  DecksMemStore.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

class DecksMemStore: DecksStoreProtocol {
    
    // MARK: - Data
    
    static let kevinCards: [Card] = [
    Card(frontSide: "Kevin's Birthday", backSide: "Sep 22"),
    Card(frontSide: "Kevin's Height", backSide: "58 in."),
    Card(frontSide: "Kevin's Age", backSide: "23")
    ]
    
    static let scienceCards: [Card] = [
    Card(frontSide: "Chemical formula of glucose", backSide: "C6H12O6"),
    Card(frontSide: "Derivative of Position", backSide: "Velocity"),
    Card(frontSide: "Derivative of Velocity", backSide: "Acceleration")
    ]
    
    static var decks = [
    Deck(nameOfDeck: "Kevin", cards: kevinCards),
    Deck(nameOfDeck: "Science", cards: scienceCards)
    ]
    
    // MARK: CRUD Operations
    
    // this just returns a [Deck] object and passes it to whoever calls this function (i.e. the worker)
    func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void) {
        // decks needs to be a static var in order to return this type - alternatively, we could just do 'return decks' if we want to pull the decks object from this memstore
        completion { return type(of: self).decks}
    }
    
    func createDeck() -> Deck {
        let newDeck = Deck(nameOfDeck: "Untitled Deck", cards: [Card(frontSide: "Test front 1", backSide: "Test front 1"), Card(frontSide: "Test front 2", backSide: "Test back 2"), Card(frontSide: "Lorem ipsum", backSide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")])
        DecksMemStore.decks.append(newDeck)
        return newDeck
    }
}
