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
    
    func decksViewHandleTapDeckCell(request: Decks.ShowDeck.Request)
    
    
    
    // Core data stuff
    
    func fetchCDDecks(request: CDDecks.FetchDecks.Request)
    
    func decksViewHandleTapCDDeckCell(request: CDDecks.ShowDeck.Request)
}

protocol DecksBusinessLogicDelegate: class {

}

protocol DecksDataStore {
    var delegate: DecksBusinessLogicDelegate? { get set }
    
    var deckInfoToPass: NaiveDeck? { get set }
    
    var decks: [NaiveDeck] { get }
    
    
    // MARK: CD Stuff
    var cdDeckInfoTopass: Deck? { get set }
    var cdDecks: [Deck] { get }
}

class DecksInteractor: DecksBusinessLogic, DecksDataStore {
  
    // MARK: Dependency Injection
    
    init(factory: DecksWorkerFactory) {
        self.decksWorker = factory.makeDecksWorker()
    }
  
    // MARK: Properties
    
    var presenter: DecksPresentationLogic!
    weak var delegate: DecksBusinessLogicDelegate?
    let decksWorker: DecksWorkerProtocol
    
    var decks: [NaiveDeck] = []
    
    var deckInfoToPass: NaiveDeck?
  
    // MARK: Setup
  
    // MARK: User Input
  
    // MARK: Private
    
    // TODO: REMOVE
    func fetchDecks(request: Decks.FetchDecks.Request) {
        decksWorker.fetchDecks { [weak self] decks in
            guard let self = self else { return }
            self.decks = decks
//            let response = Decks.FetchDecks.Response(decks: decks)
//            self.presenter.presentFetchedDecks(response: response)
        }
    }
    
    func decksViewHandleTapDeckCell(request: Decks.ShowDeck.Request) {
        let response = Decks.ShowDeck.Response(deckInfoToPass: decks[request.indexPathRow])
        presenter.presentDeckDetail(response: response)
    }
    
    
    
    
    // MARK: Core Data stuff
    
    var cdDecks: [Deck] = []
    
    var cdDeckInfoTopass: Deck?
    
    func fetchCDDecks(request: CDDecks.FetchDecks.Request) {
        cdDecks = decksWorker.fetchCDDecks()
        
        let response = CDDecks.FetchDecks.Response(decks: cdDecks)
        presenter.presentFetchedDecks(response: response)
    }
    
    func decksViewHandleTapCDDeckCell(request: CDDecks.ShowDeck.Request) {
        let response = CDDecks.ShowDeck.Response(deckInfoToPass: cdDecks[request.indexPathRow])
        presenter.presentCDDeckDetail(response: response)
    }
    
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    
    // TODO: REMOVE AFTER PORTING TO CORE DATA
    func decksViewSelectAddDeck(request: Decks.CreateDeck.Request) {
        // only need to care about completion and main queue when working with
        // serverside creation, but since we create deck within local
        // data store, it should work fine to not have async results/calls
        let newDeck = decksWorker.createDeck()
        let response = Decks.CreateDeck.Response(deckInfoToPass: newDeck)
        presenter.presentDeckDetail(response: response)
        
    }
    
    
    
    
    func decksViewSelectAddCDDeck(request: CDDecks.CreateDeck.Request) {
        guard let newDeck = decksWorker.createCDDeck() else {
            print("Error adding deck \(#line) \(#file)")
            return
        }
        
        let response = CDDecks.ShowDeck.Response(deckInfoToPass: newDeck)
        presenter.presentCDDeckDetail(response: response)
    }
    
}
