//
//  DecksPresenter.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksPresentationLogic: AlertDisplayablePresenter {
    func presentFetchedDecks(response: Decks.FetchDecks.Response)
    func presentDeckDetail(response: Decks.ShowDeck.Response)
    
    func presentEditedDecktitle(response: Decks.EditDeckTitle.Response)
    func presentDeletedDeck(response: Decks.DeleteDeck.Response)
}

class DecksPresenter: DecksPresentationLogic {
  
    // MARK: Properties
  
    weak var viewController: DecksDisplayLogic?
    var alertDisplayableViewController: AlertDisplayableViewController?
  
    // MARK: Presentation
    
    func presentFetchedDecks(response: Decks.FetchDecks.Response) {
        var displayedDeckCells: [DecksCollectionViewCell.DeckCellModel] = []
        
        // format the Deck objects we get from the response into deck cell models
        // with which the view controller will update the view
        for deck in response.decks {
            let cellModel = DecksCollectionViewCell.DeckCellModel(deckTitle: deck.name, numberOfCards: deck.cards.count)
            displayedDeckCells.append(cellModel)
        }
        
        let viewModel = Decks.FetchDecks.ViewModel(displayedDecks: displayedDeckCells)
        viewController?.displayFetchedDecks(viewModel: viewModel)
    }
    
    func presentDeckDetail(response: Decks.ShowDeck.Response) {
        let deckInfoToPass = response.deckInfoToPass
        
        // we pass the deckinfo directly instead of through an enum struct 'ViewModel'
        // since this deck can come from either the showdeck or create deck use case
        let deckModel = Decks.ShowDeck.DeckModel(deckInfoToPass: deckInfoToPass)
        viewController?.displayDeckDetail(deckInfoToPass: deckModel.deckInfoToPass)
    }
    
    
    func presentEditedDecktitle(response: Decks.EditDeckTitle.Response) {
        let viewModel = Decks.EditDeckTitle.ViewModel(newDeckTitle: response.newDeckTitle, deckIndexToUpdate: response.deckIndexToUpdate)
        viewController?.displayEditedDeckTitle(viewModel: viewModel)
    }
    
    
    func presentDeletedDeck(response: Decks.DeleteDeck.Response) {
        let viewModel = Decks.DeleteDeck.ViewModel(indexOfDeckToRemove: response.indexOfDeckToRemove)
        viewController?.displayDeletedDeck(viewModel: viewModel)
    }
  
}
