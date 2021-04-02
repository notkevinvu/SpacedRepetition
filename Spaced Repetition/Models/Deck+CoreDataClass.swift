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
    
    /**
     A method to help with setting all the attributes of a newly initialized/added Deck object
     
     Use this method after creating a Deck object
     ```
     let deck = Deck(context: managedContext)
     
     deck.initializeDeckWithValues(name:...)
     ```
     
     - Parameters:
        - name: Should take in a string typically set through user interaction (alert controller text field)
        - deckID: Inject a UUID instance here (`UUID()`)
        - dateCreated: Likewise with `deckID`, inject a Date instance here (`Date()`)
        - deckIndex: Here, we should set the deckIndex by passing in the count of the current # of decks objects.
                    By doing so, we can impose an order on how deck objects will be sorted when we fetch, rather than doing it by date created.
                    This allows us to eventually re-order the decks by moving a deck and then updating the deckIndex of all other decks by matching it to its indexPath.row in the collection view.
        - cards: We pass in an array of cards which will then be added to the deck within the initializer.
        - needsReview: By default, we initialize as true. This tracks whether or not the user needs to review the deck.
                        This will be calculated by checking if any of the deck's cards need to be reviewed that day.
     */
    public func initializeDeckWithValues(name: String, deckID: UUID, dateCreated: Date, deckIndex: Int, cards: [Card], needsReview: Bool = true) {
        self.name = name
        self.deckID = deckID
        self.dateCreated = dateCreated
        self.deckIndex = Int32(deckIndex)
        self.needsReview = needsReview
        
        for card in cards {
            self.addToCards(card)
        }
    }
    
    public func updateDeck(withNewIndex index: Int) {
        self.deckIndex = Int32(index)
    }
    
    public func reorder(card: Card, sourceIndex: Int, destinationIndex: Int) {
        self.removeFromCards(at: sourceIndex)
        self.insertIntoCards(card, at: destinationIndex)
        
        guard let managedContext = self.managedObjectContext else { return }
        
        /*
         TODO: Maybe move this out of the class method? Might want to only save
         if the user leaves the scene or closes the app (i.e. keep the possibility
         for the user to undo an action - not implemented yet though)
         */
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to save reordered cards \(error) with desc: \(error.userInfo)")
        }
    }

}
