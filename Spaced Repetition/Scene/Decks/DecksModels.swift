//
//  DecksModels.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

enum Decks {
    
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
    
    enum CreateDeck {
        /*
         only need a request here - after the request is sent to the worker/store,
         this enum has finished its role, thus we can move into ShowDeck's
         Response and DeckModel
         */
        struct Request {
        }
    }
    
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
    
    
    enum ShowDeckOptions {
        // only need request - response and viewmodel handled by alertdisplayable
        struct Request {
            let indexOfDeckToEditOrDelete: Int
        }
    }
    
    
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
    
    
    enum DeleteDeck {
        struct Response {
            let indexOfDeckToRemove: Int
        }
        struct ViewModel {
            let indexOfDeckToRemove: Int
        }
    }
}
