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
    
    public func initializeCardWith(frontSideText: String, backSideText: String, cardID: UUID, dateCreated: Date) {
        self.frontSideText = frontSideText
        self.backSideText = backSideText
        self.cardID = cardID
        self.dateCreated = dateCreated
    }

}
