//
//  Deck.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation


class NaiveDeck: Codable {
    var nameOfDeck: String
    let deckID: UUID
    
    var cards: [NaiveCard]
    
    /**
     Init for a Deck object
     
     No deckID parameter since the init initializes a UUID for the deckID by default
     
     - Parameters:
        - nameOfDeck: Defaults to "Untitled Deck"
        - cards: Defaults to an empty array
     */
    init(nameOfDeck: String = "Untitled Deck", cards: [NaiveCard] = []) {
        self.nameOfDeck = nameOfDeck
        deckID = UUID()
        self.cards = cards
    }
}


class NaiveCard: Codable {
    var frontSide: String
    var backSide: String
    
    init(frontSide: String, backSide: String) {
        self.frontSide = frontSide
        self.backSide = backSide
    }
}
