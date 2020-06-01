//
//  DecksModels.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DeckResponse {
    var deckInfoToPass: NaiveDeck { get }
}

protocol DeckInfoModel {
    var deckInfoToPass: NaiveDeck { get }
}

enum Decks {
    
    enum FetchDecks {
        struct Request {
            
        }
        struct Response {
            let decks: [NaiveDeck]
        }
        struct ViewModel {
            /*
             inside the presenter, we need to take the model (Deck) and transform it
             into the ViewModel (cell model - which is stuff like
             "Ok, we need a deck title label, a label that shows how many
             cards are in the deck, and a label that shows if we need to
             review the deck or not")
             so in that scenario, we would do something like
             var deckTitle: String = Untitled Deck (for default deck title)
             var numOfCardsInDeck: String (this should be 0 for a new deck)
            */
            let displayedDecks: [DecksCollectionViewCell.DeckCellModel]
        }
    }
    
    enum CreateDeck {
        // create deck use case - user taps create/add deck button, navigates to a new DeckDetailView (i.e. one not populated with any cards and with the title "Untitled deck")
        // flow should be user taps, button submits a request to the interactor
        // the interactor will then add an empty Deck object to the memory store
        struct Request {
            // don't need any object from the request,
            // since once we tap the add deck button, it should make a default empty deck
        }
        struct Response: DeckResponse {
            let deckInfoToPass: NaiveDeck
        }
        struct DeckModel: DeckInfoModel {
            let deckInfoToPass: NaiveDeck
        }
    }
    
    enum ShowDeck {
        // the ShowDeck.Request struct is initialized with an indexPathRow Int
        // to grab the corresponding deck from the decks array in the interactor
        // i.e. the dataStore for the router
        struct Request {
            let indexPathRow: Int
        }
        struct Response: DeckResponse {
            let deckInfoToPass: NaiveDeck
        }
        struct DeckModel: DeckInfoModel {
            let deckInfoToPass: NaiveDeck
        }
        
    }
  
}
