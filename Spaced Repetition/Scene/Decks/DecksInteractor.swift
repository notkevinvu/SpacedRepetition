//
//  DecksInteractor.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksBusinessLogic: DecksViewDelegate {
    func fetchDecks(request: Decks.FetchDecks.Request)
}

protocol DecksBusinessLogicDelegate: class {

}

protocol DecksDataStore {
    var delegate: DecksBusinessLogicDelegate? { get set }
}

class DecksInteractor: DecksBusinessLogic, DecksDataStore {
  
    // MARK: Dependency Injection
  
    // MARK: Properties
  
    var presenter: DecksPresentationLogic!
    weak var delegate: DecksBusinessLogicDelegate?
    var decksWorker = DecksWorker(decksStore: DecksMemStore())
    
    var decks: [Deck] = []
  
    // MARK: Setup
  
    // MARK: User Input
  
    // MARK: Private
    
    func fetchDecks(request: Decks.FetchDecks.Request) {
        decksWorker.fetchDecks { (decks) in
            self.decks = decks
            let response = Decks.FetchDecks.Response(decks: decks)
            self.presenter.presentFetchedDecks(response: response)
        }
    }
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    func decksViewSelectAddDeck() {
        // TODO: Create a deck
        
        presenter.presentDeckDetail()
    }
    
}
