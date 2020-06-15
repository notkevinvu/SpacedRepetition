//
//  Card+CoreDataProperties.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 6/14/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func cardFetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var backSideText: String
    @NSManaged public var cardID: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var frontSideText: String
    @NSManaged public var reviewStatus: String
    @NSManaged public var dateLastReviewed: Date?
    @NSManaged public var needsReview: Bool
    @NSManaged public var deck: Deck?

}
