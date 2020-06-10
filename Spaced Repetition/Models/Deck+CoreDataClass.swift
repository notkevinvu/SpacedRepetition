//
//  Deck+CoreDataClass.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 6/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Deck)
public class Deck: NSManagedObject {
    
    public func initializeDeckWithValues(name: String, deckID: UUID, dateCreated: Date, cards: [Card]) {
        self.name = name
        self.deckID = deckID
        self.dateCreated = dateCreated
        
        for card in cards {
            self.addToCards(card)
        }
    }

}
