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
    
    func showDeckOptions(request: Decks.ShowDeckOptions.Request)
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
    
    init(factory: DecksWorkerFactory) {
        self.decksWorker = factory.makeDecksWorker()
    }
  
    // MARK: Properties
    
    var presenter: DecksPresentationLogic!
    weak var delegate: DecksBusinessLogicDelegate?
    let decksWorker: DecksWorkerProtocol
    
    
    var decks: [Deck] = []
       
    var deckInfoToPass: Deck?
  
    // MARK: Setup
  
    // MARK: User Input
  
    
    // MARK: Fetching decks
    
    func fetchDecks(request: Decks.FetchDecks.Request) {
        decks = decksWorker.fetchCDDecks()
        
        let response = Decks.FetchDecks.Response(decks: decks)
        presenter.presentFetchedDecks(response: response)
    }
    
    
    func decksViewHandleTapDeckCell(request: Decks.ShowDeck.Request) {
        let response = Decks.ShowDeck.Response(deckInfoToPass: decks[request.indexPathRow])
        presenter.presentDeckDetail(response: response)
    }
    
    
    func showDeckOptions(request: Decks.ShowDeckOptions.Request) {
        
        let cancelAction = AlertDisplayable.Action(title: "Cancel", style: .cancel, handler: nil)
        
        let editDeckTitleAction = AlertDisplayable.Action(title: "Edit deck title", style: .default) { [weak self] (action, ac) in
            
            guard let self = self else { return }
            
            print("Editing deck title")
        }
        
        let deleteDeckAction = AlertDisplayable.Action(title: "Delete deck", style: .destructive) { [weak self] (action, ac) in
            
            guard let self = self else { return }
            
            print("Deleting deck")
        }
        
        let viewModel = AlertDisplayable.ViewModel(title: nil, message: nil, textFields: [], actions: [cancelAction, editDeckTitleAction, deleteDeckAction])
        presenter.presentAlert(viewModel: viewModel, alertStyle: .actionSheet)
    }
    
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    func decksViewHandleTapAddDeckButton(request: Decks.CreateDeck.Request) {
        guard let newDeck = decksWorker.createCDDeck() else {
            print("Error adding deck \(#line) \(#file)")
            return
        }
        
        let response = Decks.ShowDeck.Response(deckInfoToPass: newDeck)
        presenter.presentDeckDetail(response: response)
    }
    
}
