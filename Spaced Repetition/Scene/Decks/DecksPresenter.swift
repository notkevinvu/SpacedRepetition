//
//  DecksPresenter.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksPresentationLogic {
    
    func presentFetchedDecks(response: Decks.FetchDecks.Response)
    
    func presentDeckDetail(response: DeckResponse)
    
    
    
    // MARK: CD Methods
    func presentFetchedDecks(response: CDDecks.FetchDecks.Response)
    func presentCDDeckDetail(response: CDDecks.ShowDeck.Response)
}

class DecksPresenter: DecksPresentationLogic {
  
    // MARK: Properties
  
    weak var viewController: DecksDisplayLogic?
  
    // MARK: Presentation
    
    // TODO: REMOVE AFTER PORTING TO CORE DATA
    func presentFetchedDecks(response: Decks.FetchDecks.Response) {
        var displayedDecksCells: [DecksCollectionViewCell.DeckCellModel] = []
        
        // format the Deck objects we get from the response into deck cell models
        // with which the view controller will update the view
        for deck in response.decks {
            let cellModel = DecksCollectionViewCell.DeckCellModel(deckTitle: deck.nameOfDeck, numberOfCards: deck.cards.count)
            displayedDecksCells.append(cellModel)
        }
        
        let viewModel = Decks.FetchDecks.ViewModel(displayedDecks: displayedDecksCells)
        viewController?.displayFetchedDecks(viewModel: viewModel)
    }
    
    // DeckResponse can either be a Decks.CreateDeck.Response or Decks.ShowDeck.Response object
    func presentDeckDetail(response: DeckResponse) {
        let deckInfoToPass = response.deckInfoToPass
        
        // this deckModel is created via a CreateDeck.DeckModel, but it can
        // be either from the CreateDeck use case or the ShowDeck use case
        // does it matter if it passes the same type of data anyway?
        let deckModel = Decks.CreateDeck.DeckModel(deckInfoToPass: deckInfoToPass)
        viewController?.displayDeckDetail(deckInfoToPass: deckModel.deckInfoToPass)
    }
    
    
    
    
    
    
    
    
    // MARK: - CD Methods
    
    func presentFetchedDecks(response: CDDecks.FetchDecks.Response) {
        var displayedDeckCells: [DecksCollectionViewCell.DeckCellModel] = []
        
        for deck in response.decks {
            let cellModel = DecksCollectionViewCell.DeckCellModel(deckTitle: deck.name, numberOfCards: deck.cards.count)
            displayedDeckCells.append(cellModel)
        }
        
        let viewModel = CDDecks.FetchDecks.ViewModel(displayedDecks: displayedDeckCells)
        viewController?.displayFetchedCDDecks(viewModel: viewModel)
    }
    
    func presentCDDeckDetail(response: CDDecks.ShowDeck.Response) {
        let deckInfoToPass = response.deckInfoToPass
        
        let deckModel = CDDecks.ShowDeck.DeckModel(deckInfoToPass: deckInfoToPass)
        viewController?.displayCDDeckDetail(deckInfoToPass: deckModel.deckInfoToPass)
    }
  
}
