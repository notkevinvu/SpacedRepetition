//
//  Card+CoreDataClass.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 6/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {
    
    enum ReviewStatus {
        case everyDay, everyTwoDays, everyThreeDays, onceAWeek
    }
    
    
    /**
    A method to help with setting all the attributes of a newly initialized/added Card object
    
    Use this method after creating a Card object
    ```
    let card = Card(context: managedContext)
    
    card.initializeDeckWithValues(frontSideText:...)
    ```
     
    Note that we don't need a cardIndex attribute/property since cards exist in an NSOrderedSet (and thus, an
    NSMutableOrderedSet by extension if we convert it). This allows us to reorder cards by using the
    moveObjects(at:) method of NSMutableOrderedSets to move the desired objects.
     ```
     guard let mutableCardSet = deck.cards.mutableCopy() as? NSMutableOrderedSet else { return }
     
     let indexOfObjectToMove = IndexSet(integer: 4)
     // 4 being the index of the object we want to move
     
     mutableCardSet.moveObjects(at: indexOfObjectToMove, to: 0)
     // 0 being the new index we want to move it to
     
     deck.cards = mutableCardSet
     
     // then we save using do { try ...save() etc }
     ```
    
    - Parameters:
       - frontSideText: Should take in a string typically set through user interaction (alert controller text field)
       - backSideText: See `frontSideText`
       - reviewStatus: We pass in a strongly typed enum case which defaults to .everyDay (since any
     new card should start from the highest priority and as the user continues to review, it will go up
       - cardID: Inject a `UUID()` instance here
       - dateCreated: Likewise with `cardID`, inject a Date instance here (`Date()`)
    */
    func initializeCardWith(frontSideText: String, backSideText: String, reviewStatus: ReviewStatus = .everyDay, cardID: UUID, dateCreated: Date, dateLastReviewed: Date? = nil) {
        // TODO: Just pass instances of Date() and UUID() as default values?
        // May help clean up initialization code
        
        self.frontSideText = frontSideText
        self.backSideText = backSideText
        self.cardID = cardID
        self.dateCreated = dateCreated
        self.dateLastReviewed =  dateLastReviewed
        
        switch reviewStatus {
        case .everyDay:
            self.reviewStatus = "everyDay"
        case .everyTwoDays:
            self.reviewStatus = "everyTwoDays"
        case .everyThreeDays:
            self.reviewStatus = "everyThreeDays"
        case .onceAWeek:
            self.reviewStatus = "onceAWeek"
        }
    }

}
