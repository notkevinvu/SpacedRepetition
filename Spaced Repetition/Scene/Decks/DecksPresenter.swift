//
//  DecksPresenter.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksPresentationLogic {
    func presentDeckDetail()
}

class DecksPresenter: DecksPresentationLogic {
  
    // MARK: Properties
  
    weak var viewController: DecksDisplayLogic?
  
    // MARK: Presentation
    
    func presentDeckDetail() {
        viewController?.displayDeckDetail()
    }
  
}
