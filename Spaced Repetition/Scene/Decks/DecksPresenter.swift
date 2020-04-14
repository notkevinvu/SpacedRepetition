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
}

class DecksPresenter: DecksPresentationLogic {
  
    // MARK: Properties
  
    weak var viewController: DecksDisplayLogic?
  
    // MARK: Presentation
    
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
  
}
