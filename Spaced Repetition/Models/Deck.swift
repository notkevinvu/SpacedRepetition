//
//  Deck.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

struct Deck {
    // immutability > mutability
    let nameOfDeck: String
    
    let cards: [Card]
}

struct Card {
    let frontSide: String
    let backSide: String
}
