//
//  Deck.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

struct Deck {
    var nameOfDeck: String
    
    var cards: [Card]
}

struct Card {
    var frontSide: String
    var backSide: String
}
