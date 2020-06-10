//
//  DecksRouter.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

@objc protocol DecksRoutingLogic {
    func routeToCDDeckDetail()
}

protocol DecksDataPassing {
    var dataStore: DecksDataStore? { get set }
}

class DecksRouter: NSObject, DecksRoutingLogic, DecksDataPassing {
    weak var viewController: DecksViewController?
    var dataStore: DecksDataStore?
    
    // MARK: Routing
    
    func routeToCDDeckDetail() {
        // if indexPath == nil, proceed to navigating after default data passing
        // TODO: review this idea if the current implementation of
        // handling deck cell tap is not logical (i.e. conforming two
        // model Responses to one protocol and the presenter function
        // takes in any object that conforms to that protocol
        
        let destinationVC = DeckDetailViewController()
        var destinationDS = destinationVC.router!.dataStore
        passCDDataToDeckDetail(fromDataStore: dataStore!, toDataStore: &destinationDS!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    // MARK: Navigation
    
    
    // MARK: Passing data
    
    
    func passCDDataToDeckDetail(fromDataStore: DecksDataStore, toDataStore: inout DeckDetailDataStore) {
        toDataStore.deckInfo = fromDataStore.deckInfoToPass
    }
    
}
