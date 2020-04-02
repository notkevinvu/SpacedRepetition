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
    
}
