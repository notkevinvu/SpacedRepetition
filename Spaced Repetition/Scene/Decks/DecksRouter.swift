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
    
    func routeToDeckDetailFromCollection(indexPath: IndexPath)
}

protocol DecksDataPassing {
    var dataStore: DecksDataStore? { get set }
}

class DecksRouter: NSObject, DecksRoutingLogic, DecksDataPassing {
    weak var viewController: DecksViewController?
    var dataStore: DecksDataStore?
    
    // MARK: Routing
    
    func routeToDeckDetail() {
        // if indexPath == nil, proceed to navigating after default data passing
        // TODO: review this idea if the current implementation of
        // handling deck cell tap is not logical (i.e. conforming two
        // model Responses to one protocol and the presenter function
        // takes in any object that conforms to that protocol
        
        /*
         this code currently not working - I think using indexPath.row to
         get the corresponding deck is correct, just need to figure out
         how to get the list of decks from the router
         
         maybe we can pass both the cell model and the deck itself
         from presenter to the VC so that we can have the deck as reference
         */
        let destinationVC = DeckDetailViewController()
        var destinationDS = destinationVC.router!.dataStore
        passDataToDeckDetail(fromDataStore: dataStore!, toDataStore: &destinationDS!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToDeckDetailFromCollection(indexPath: IndexPath) {
//        let destinationVC = DeckDetailViewController()
//        var destinationDS = destinationVC.router!.dataStore
//        passDataToDeckDetail(fromDataStore: dataStore!, toDataStore: &destinationDS!)
//        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Navigation
    
    
    // MARK: Passing data
    
    func passDataToDeckDetail(fromDataStore: DecksDataStore, toDataStore: inout DeckDetailDataStore) {
        toDataStore.deckInfo = fromDataStore.deckInfoToPass
    }
    
}
