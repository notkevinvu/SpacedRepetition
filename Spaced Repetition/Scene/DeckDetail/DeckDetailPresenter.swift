//
//  DeckDetailPresenter.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/3/20.
//  Copyright (c) 2020 An Nguyen. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DeckDetailPresentationLogic: AlertDisplayablePresenter
{
    func presentDeck(response: DeckDetail.ShowDeck.Response)
    
    func presentCard(response: DeckDetail.CreateCard.Response)
    
    func presentEditedDeckTitle(response: DeckDetail.ShowEditTitleAlert.Response)
}

protocol AlertDisplayablePresenter {
    var alertDisplayableViewController: AlertDisplayableViewController? { get }
    func presentAlert(viewModel: AlertDisplayable.ViewModel)
}

// MARK: AlertController implementation
extension AlertDisplayablePresenter {
    // default implementation of any AlertDisplayablePresenter
    public func presentAlert(viewModel: AlertDisplayable.ViewModel) {
        alertDisplayableViewController?.displayAlert(viewModel: viewModel)
    }
}

class DeckDetailPresenter: DeckDetailPresentationLogic
{
    
    // MARK: Properties
    
    weak var viewController: DeckDetailDisplayLogic?
    var alertDisplayableViewController: AlertDisplayableViewController?
    
    // MARK: Present something
    
    func presentDeck(response: DeckDetail.ShowDeck.Response) {
        let deck = response.deck
        
        // name formatting for viewmodel
        let nameOfDeck = deck.nameOfDeck
        let deckNameModel = DeckDetail.ShowDeck.ViewModel.DeckInfoModel(displayedDeckName: nameOfDeck, displayedDeckID: deck.deckID)
        viewController?.displayDeckName(viewModel: deckNameModel)
        
        // card formatting for viewmodel
        var cards: [DeckDetailCollectionViewCell.CardCellModel] = []
        
        for card in deck.cards {
            let cellModel = DeckDetailCollectionViewCell.CardCellModel(frontSide: card.frontSide, backSide: card.backSide)
            cards.append(cellModel)
        }
        
        let cardViewModel = DeckDetail.ShowDeck.ViewModel.DeckCardModels(displayedCards: cards)
        viewController?.displayDeckCards(viewModel: cardViewModel)
    }
    
    func presentCard(response: DeckDetail.CreateCard.Response) {
        let cardCellModel = DeckDetailCollectionViewCell.CardCellModel(frontSide: response.card.frontSide, backSide: response.card.backSide)
        let cardViewModel = DeckDetail.CreateCard.ViewModel(displayedCard: cardCellModel)
        viewController?.displayCreatedCard(viewModel: cardViewModel)
    }
    
    
    func presentEditedDeckTitle(response: DeckDetail.ShowEditTitleAlert.Response) {
        let viewModel = DeckDetail.ShowEditTitleAlert.ViewModel(newDeckTitle: response.newDeckTitle)
        viewController?.displayEditedDeckTitle(viewModel: viewModel)
    }
}
