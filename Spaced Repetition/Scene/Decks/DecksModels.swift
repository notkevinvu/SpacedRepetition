//
//  DecksModels.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

enum Decks {
    
    // MARK: Fetch decks
    enum FetchDecks {
        struct Request {
            
        }
        
        struct Response {
            let decks: [Deck]
        }
        
        struct ViewModel {
            let displayedDecks: [DecksCollectionViewCell.DeckCellModel]
        }
    }
    
    // MARK: Update cell models
    enum UpdateDeckCellModels {
        struct Request {
        }
        struct Response {
            let decks: [Deck]
        }
        struct ViewModel {
            let displayedDecks: [DecksCollectionViewCell.DeckCellModel]
        }
    }
    
    // MARK: Create deck
    enum CreateDeck {
        /*
         only need a request here - after the request is sent to the worker/store,
         this enum has finished its role, thus we can move into ShowDeck's
         Response and DeckModel
         */
        struct Request {
        }
    }
    
    // MARK: Show deck
    enum ShowDeck {
        struct Request {
            let indexPathRow: Int
        }
        
        struct Response {
            let deckInfoToPass: Deck
        }
        
        struct DeckModel {
            let deckInfoToPass: Deck
        }
    }
    
    // MARK: Show deck options
    enum ShowDeckOptions {
        // only need request - response and viewmodel handled by alertdisplayable
        struct Request {
            let indexOfDeckToEditOrDelete: Int
        }
    }
    
    // MARK: Edit deck title
    enum EditDeckTitle {
        // no need for request - starts from interactor
        struct Response {
            let newDeckTitle: String
            let deckIndexToUpdate: Int
        }
        struct ViewModel {
            let newDeckTitle: String
            let deckIndexToUpdate: Int
        }
    }
    
    // MARK: Delete deck
    enum DeleteDeck {
        struct Response {
            let indexOfDeckToRemove: Int
        }
        struct ViewModel {
            let indexOfDeckToRemove: Int
        }
    }
}
