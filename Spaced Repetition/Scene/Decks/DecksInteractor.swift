//
//  DecksInteractor.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksBusinessLogic: DecksViewDelegate {
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
  
    // MARK: Setup
  
    // MARK: User Input
  
    // MARK: Private
}

// MARK: - DecksViewDelegate
extension DecksInteractor: DecksViewDelegate {
    
    func decksViewSelectAddDeck() {
        // TODO: Create a deck
        
        presenter.presentDeckDetail()
    }
    
}
