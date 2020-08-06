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
    
    func updateDeckCellModels(request: Decks.UpdateDeckCellModels.Request)
    
    func reorderDeck(request: Decks.ReorderDeck.Request)
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

  
    // MARK: Fetching decks
    
    func fetchDecks(request: Decks.FetchDecks.Request) {
        decks = decksWorker.fetchDecks()
        
        // this checks and updates every deck
        decksWorker.checkIfDecksNeedsReview(decks: decks)
        
        let response = Decks.FetchDecks.Response(decks: decks)
        presenter.presentFetchedDecks(response: response)
    }
    
    // MARK: Update deck cell models
    func updateDeckCellModels(request: Decks.UpdateDeckCellModels.Request) {
        let response = Decks.UpdateDeckCellModels.Response(decks: decks)
        presenter.presentUpdateDeckCellModels(response: response)
    }
    
    
    // MARK: Handle tap deck cell
    func decksViewHandleTapDeckCell(request: Decks.ShowDeck.Request) {
        let response = Decks.ShowDeck.Response(deckInfoToPass: decks[request.indexPathRow])
        presenter.presentDeckDetail(response: response)
    }
    
    
    // MARK: Show Deck Options
    // TODO: Refactor action handlers to call worker methods to free up space in interactor
    func showDeckOptions(request: Decks.ShowDeckOptions.Request) {
        let indexOfDeckToEditOrDelete = request.indexOfDeckToEditOrDelete
        let deckToEditOrDelete = decks[indexOfDeckToEditOrDelete]
        
        let cancelAction = AlertDisplayable.Action(title: "Cancel", style: .cancel, handler: nil)
        
        
        // MARK: - Edit deck title
        
        let editDeckTitleAction = AlertDisplayable.Action(title: "Edit deck title", style: .default) { [weak self] (action1, ac1) in
            
            // selecting this action on the alertsheet presents another alert,
            // for which we create new actions for here
            guard let self = self else { return }
            
            let deckTitleTextFieldPlaceholder = AlertDisplayable.TextField(placeholder: "New deck name...")
            
            let cancelNewDeckTitleAction = AlertDisplayable.Action(title: "Cancel", style: .cancel, handler: nil)
            
            let saveNewDeckTitleAction = AlertDisplayable.Action(title: "Done", style: .default) { (action2, ac2) in
                
                guard
                    let newDeckTitle = ac2.textFields?[0].text,
                    !newDeckTitle.isEmpty
                    else { return }
                
                self.decksWorker.editDeckTitle(forDeck: deckToEditOrDelete, withNewTitle: newDeckTitle)
                
                let response = Decks.EditDeckTitle.Response(newDeckTitle: newDeckTitle, deckIndexToUpdate: indexOfDeckToEditOrDelete)
                self.presenter.presentEditedDecktitle(response: response)
            }
            
            let viewModel = AlertDisplayable.ViewModel(title: "Edit deck name", message: "Please enter a new name for the deck", textFields: [deckTitleTextFieldPlaceholder], actions: [cancelNewDeckTitleAction, saveNewDeckTitleAction])
            self.presenter.presentAlert(viewModel: viewModel, alertStyle: .alert)
        }
        
        
        // MARK: - Delete deck
        
        let deleteDeckAction = AlertDisplayable.Action(title: "Delete deck", style: .destructive) { [weak self] (action, ac) in
            
            guard let self = self else { return }
            
            let cancelDeleteDeckAction = AlertDisplayable.Action(title: "Cancel", style: .cancel, handler: nil)
            
            let saveDeleteDeckAction = AlertDisplayable.Action(title: "Confirm", style: .destructive) { (action, ac) in
                
                self.decksWorker.deleteDeck(deck: deckToEditOrDelete)
                self.decks.remove(at: indexOfDeckToEditOrDelete)
                
                let response = Decks.DeleteDeck.Response(indexOfDeckToRemove: indexOfDeckToEditOrDelete)
                self.presenter.presentDeletedDeck(response: response)
            }
            
            let viewModel = AlertDisplayable.ViewModel(title: "Confirm delete", message: "Are you sure you want to delete this deck?", textFields: [], actions: [cancelDeleteDeckAction, saveDeleteDeckAction])
            self.presenter.presentAlert(viewModel: viewModel, alertStyle: .alert)
        }
        
        
        let viewModel = AlertDisplayable.ViewModel(title: nil, message: nil, textFields: [], actions: [cancelAction, editDeckTitleAction, deleteDeckAction])
        presenter.presentAlert(viewModel: viewModel, alertStyle: .actionSheet)
    }
    
    // MARK: Reorder deck
    func reorderDeck(request: Decks.ReorderDeck.Request) {
        
        let deckToMove = decks.remove(at: request.sourceIndex)
        decks.insert(deckToMove, at: request.destinationIndex)
        
        decksWorker.updateDeckOrder(decks: decks)
    }
    
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    func decksViewHandleTapAddDeckButton(request: Decks.CreateDeck.Request) {
        guard let newDeck = decksWorker.createDeck() else {
            assertionFailure("Error adding deck \(#line), \(#file)")
            return
        }
        
        decks.append(newDeck)
        
        let response = Decks.ShowDeck.Response(deckInfoToPass: newDeck)
        presenter.presentDeckDetail(response: response)
    }
    
}
