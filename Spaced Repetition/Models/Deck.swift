//
//  Deck.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

// might be better to use a class instead of struct if we change anything
struct Deck {
    var nameOfDeck: String
    let deckID: UUID
    
    var cards: [Card]
}

struct Card {
    var frontSide: String
    var backSide: String
}
