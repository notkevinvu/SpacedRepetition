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
    
    var deckInfoToPass: Deck? { get set }
    
    var decks: [Deck] { get }
}

class DecksInteractor: DecksBusinessLogic, DecksDataStore {
  
    // MARK: Dependency Injection
  
    // MARK: Properties
  
    var presenter: DecksPresentationLogic!
    weak var delegate: DecksBusinessLogicDelegate?
    var decksWorker = DecksWorker(decksStore: DecksMemStore())
    
    var decks: [Deck] = []
    
    var deckInfoToPass: Deck?
  
    // MARK: Setup
  
    // MARK: User Input
  
    // MARK: Private
    
    func fetchDecks(request: Decks.FetchDecks.Request) {
        decksWorker.fetchDecks { [weak self] decks in
            guard let self = self else { return }
            self.decks = decks
            let response = Decks.FetchDecks.Response(decks: decks)
            self.presenter.presentFetchedDecks(response: response)
        }
    }
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    func decksViewSelectAddDeck(request: Decks.CreateDeck.Request) {
        decksWorker.createDeck { [weak self] (deck) in
            guard let self = self else { return }
            
            let response = Decks.CreateDeck.Response(deckInfoToPass: deck)
            self.presenter.presentDeckDetail(response: response)
        }
        
        
    }
    
}
