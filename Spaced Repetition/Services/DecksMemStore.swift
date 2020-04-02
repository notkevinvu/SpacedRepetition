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
    
    static var kevinCards: [Card] = [
    Card(frontSide: "Kevin's Birthday", backSide: "Sep 22"),
    Card(frontSide: "Kevin's Height", backSide: "58 in."),
    Card(frontSide: "Kevin's Age", backSide: "23")
    ]
    
    static var scienceCards: [Card] = [
    Card(frontSide: "Chemical formula of glucose", backSide: "C6H12O6"),
    Card(frontSide: "Derivative of Position", backSide: "Velocity"),
    Card(frontSide: "Derivative of Velocity", backSide: "Acceleration")
    ]
    
    static var decks = [
    Deck(nameOfDeck: "Kevin", cards: kevinCards),
    Deck(nameOfDeck: "Science", cards: scienceCards)
    ]
    
    func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void) {
        completion { return type(of: self).decks}
    }
}
