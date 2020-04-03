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
    
    func presentDeckDetail()
}

class DecksPresenter: DecksPresentationLogic {
  
    // MARK: Properties
  
    weak var viewController: DecksDisplayLogic?
  
    // MARK: Presentation
    
    func presentFetchedDecks(response: Decks.FetchDecks.Response) {
        var displayedDecks: [Deck] = []
        
        for deck in response.decks {
            displayedDecks.append(deck)
        }
        
        let viewModel = Decks.FetchDecks.ViewModel(displayedDecks: displayedDecks)
        viewController?.displayFetchedDecks(viewModel: viewModel)
    }
    
    func presentDeckDetail() {
        viewController?.displayDeckDetail()
    }
  
}
