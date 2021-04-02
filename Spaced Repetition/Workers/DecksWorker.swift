//
//  DecksWorker.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation
import CoreData

protocol DecksWorkerFactory {
    func makeDecksWorker() -> DecksWorkerProtocol
}


protocol DecksWorkerProtocol {
    func fetchDecks(completion: @escaping ([Deck]) -> () )
    func checkIfDecksNeedsReview(decks: [Deck])
    
    func createDeck() -> Deck?
    func editDeckTitle(forDeck deck: Deck, withNewTitle newTitle: String)
    func deleteDeck(deck: Deck)
    func updateDeckOrder(decks: [Deck])
    
    func createCard(withCardModel cardModel: CardModel, forDeck deck: Deck)
    func editCard(cardToEdit card: Card, newFrontText: String, newBackText: String)
    func deleteCard(card: Card, fromDeck deck: Deck)
}


final class DecksWorker {
    typealias Factory = DecksStoreFactory
    
    private let decksStore: DecksStoreProtocol
    
    init(factory: Factory) {
        self.decksStore = factory.makeDecksStore()
    }
}

// MARK: - DecksWorker protocol methods
extension DecksWorker: DecksWorkerProtocol {
    
    
    // MARK: - Fetch decks
    func fetchDecks(completion: @escaping ([Deck]) -> () ) {
        decksStore.fetchDecks { (decks) in
            completion(decks)
        }
    }
    
    // MARK: Check if decks need review
    func checkIfDecksNeedsReview(decks: [Deck]) {
        
        for deck in decks {
            let cardsFromDeck = deck.cards.array as! [Card]
            
            for card in cardsFromDeck {
                
                guard let dateLastReviewed = card.dateLastReviewed else {
                    /*
                     TODO: if a card does not yet have a date last reviewed,
                     it must be a new card and the deck needs to be reviewed
                     */
                    return
                }
                
                let calendar = Calendar.current
                
                guard
                    let formattedDateLastReviewed = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: dateLastReviewed),
                    let formattedCurrentDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
                    else {
                        return
                }
                
                let components = calendar.dateComponents([.day], from: formattedDateLastReviewed, to: formattedCurrentDate)
                
                guard let daysSinceLastReviewed = components.day else {
                    assertionFailure("Couldn't get day count from dateComponents \(#line) - \(#file)")
                    return
                }
                
                switch card.reviewStatus {
                case Card.ReviewStatus.everyDay.rawValue:
                    if daysSinceLastReviewed >= 1 {
                        deck.needsReview = true
                        // if even one card in a deck needs review, the deck
                        // needs to be reviewed (well, the relevant cards at least)
                        saveContext(managedContext: deck.managedObjectContext)
                        return
                    } else {
                        continue
                    }
                case Card.ReviewStatus.everyTwoDays.rawValue:
                    if daysSinceLastReviewed >= 2 {
                        deck.needsReview = true
                        saveContext(managedContext: deck.managedObjectContext)
                        return
                    } else {
                        continue
                    }
                case Card.ReviewStatus.everyThreeDays.rawValue:
                    if daysSinceLastReviewed >= 3 {
                        deck.needsReview = true
                        saveContext(managedContext: deck.managedObjectContext)
                        return
                    } else {
                        continue
                    }
                case Card.ReviewStatus.onceAWeek.rawValue:
                    if daysSinceLastReviewed >= 7 {
                        deck.needsReview = true
                        saveContext(managedContext: deck.managedObjectContext)
                        return
                    } else {
                        continue
                    }
                case Card.ReviewStatus.retired.rawValue:
                    continue
                default:
                    assertionFailure("Somehow card's review status wasn't one of the enum raw values \(#line) - \(#file)")
                    continue
                }
                
                
            }
        }
        
    }
    
    // MARK: - Create deck
    func createDeck() -> Deck? {
        guard let deck = decksStore.createDeck() else { return nil }
        
        return deck
    }
    
    // MARK: - Edit deck title
    func editDeckTitle(forDeck deck: Deck, withNewTitle newTitle: String) {
        deck.name = newTitle
        
        guard let managedContext = deck.managedObjectContext else {
            assertionFailure("Failed to get managed context \(#line), \(#file)")
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to save new deck title - \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Delete deck
    func deleteDeck(deck: Deck) {
        
        guard let managedContext = deck.managedObjectContext else {
            assertionFailure("Failed to get managed context \(#line), \(#file)")
            return
        }
        
        managedContext.delete(deck)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to delete deck and save - \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Create card
    func createCard(withCardModel cardModel: CardModel, forDeck deck: Deck) {
        guard let managedContext = deck.managedObjectContext else { return }
        
        let cardToCreate = Card(context: managedContext)
        cardToCreate.initializeCardWith(frontSideText: cardModel.frontSideText, backSideText: cardModel.backSideText, cardID: cardModel.cardID, dateCreated: cardModel.dateCreated)
        
        deck.addToCards(cardToCreate)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            assertionFailure("Failed to create and save new card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Update Deck order
    func updateDeckOrder(decks: [Deck]) {
        for (index, deck) in decks.enumerated() {
            guard let managedContext = deck.managedObjectContext else { return }
            
            deck.updateDeck(withNewIndex: index)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                assertionFailure("Failed to update deck order line: \(#line), \(#file) -- error: \(error) with desc: \(error.userInfo)")
                return
            }
        }
    }
    
    
    // MARK: - Edit card
    func editCard(cardToEdit card: Card, newFrontText: String, newBackText: String) {
        card.frontSideText = newFrontText
        card.backSideText = newBackText
        
        do {
            try card.managedObjectContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to edit and save card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    // MARK: - Delete card
    func deleteCard(card: Card, fromDeck deck: Deck) {
        deck.removeFromCards(card)
        
        do {
            try deck.managedObjectContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to delete card \(#line), \(#file) - error: \(error) with desc: \(error.userInfo)")
            return
        }
    }
    
    
    func saveContext(managedContext: NSManagedObjectContext?) {
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            assertionFailure("Failed to save managed context \(#line) - \(#file) - error: \(error) with desc: \(error.userInfo)")
        }
    }
    
}
