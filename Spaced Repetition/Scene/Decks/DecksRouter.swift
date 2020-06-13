//
//  DecksRouter.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

@objc protocol DecksRoutingLogic {
    func routeToDeckDetail()
}

protocol DecksDataPassing {
    var dataStore: DecksDataStore? { get set }
}

class DecksRouter: NSObject, DecksRoutingLogic, DecksDataPassing {
    weak var viewController: DecksViewController?
    var dataStore: DecksDataStore?
    
    // MARK: Routing
    
    func routeToDeckDetail() {
        let destinationVC = DeckDetailViewController()
        var destinationDS = destinationVC.router!.dataStore
        passDataToDeckDetail(fromDataStore: dataStore!, toDataStore: &destinationDS!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    // MARK: Navigation
    
    
    // MARK: Passing data
    
    
    func passDataToDeckDetail(fromDataStore: DecksDataStore, toDataStore: inout DeckDetailDataStore) {
        toDataStore.deckInfo = fromDataStore.deckInfoToPass
    }
    
}
