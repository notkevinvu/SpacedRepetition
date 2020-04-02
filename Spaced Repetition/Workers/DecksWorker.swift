//
//  DecksWorker.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

protocol DecksStoreProtocol {
    func fetchDecks(completion: @escaping (() throws -> [Deck]) -> Void)
}

class DecksWorker {
    var decksStore: DecksStoreProtocol
    
    init(decksStore: DecksStoreProtocol) {
        self.decksStore = decksStore
    }
    
    // fetchDecks should give a [Deck] object when it is finished being called
    func fetchDecks(completion: @escaping ([Deck]) -> Void) {
        decksStore.fetchDecks { (decks: () throws -> [Deck]) -> Void in
            do {
                let decks = try decks()
                DispatchQueue.main.async {
                    // passes out a [Deck] object as the decks variable
                    completion(decks)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}
