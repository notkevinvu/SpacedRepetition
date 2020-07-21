//
//  ExpandedCardDetailInteractor.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 7/20/20.
//  Copyright (c) 2020 An Nguyen. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ExpandedCardDetailBusinessLogic {
    
}

protocol ExpandedCardDetailDataStore {
    var cardInfo: Card? { get set }
}

class ExpandedCardDetailInteractor: ExpandedCardDetailBusinessLogic, ExpandedCardDetailDataStore {
    
    var presenter: ExpandedCardDetailPresentationLogic?
    var cardInfo: Card?

    // MARK: Do something
    
}
