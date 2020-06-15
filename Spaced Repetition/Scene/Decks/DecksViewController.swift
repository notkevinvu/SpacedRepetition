//
//  DecksViewController.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksDisplayLogic: class {
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel)
    
    func displayDeckDetail(deckInfoToPass: Deck)
    
    func displayUpdatedDeckCellModels(viewModel: Decks.UpdateDeckCellModels.ViewModel)
    
    func displayEditedDeckTitle(viewModel: Decks.EditDeckTitle.ViewModel)
    
    func displayDeletedDeck(viewModel: Decks.DeleteDeck.ViewModel)
}

class DecksViewController: UIViewController, DecksDisplayLogic, AlertDisplayableViewController {
    
    // MARK: Properties
    
    var interactor: DecksBusinessLogic?
    var router: (NSObjectProtocol & DecksRoutingLogic & DecksDataPassing)!
    var contentView: DecksView!

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = DecksInteractor(factory: DependencyContainer())
        let presenter = DecksPresenter()
        let router = DecksRouter()
        let view = DecksView()
        
        viewController.interactor = interactor
        viewController.router = router
        viewController.contentView = view
        interactor.presenter = presenter
        presenter.viewController = viewController
        presenter.alertDisplayableViewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        view.delegate = interactor
    }
    
    private func configureCollectionViewSource() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
    
    private func configureNavigationbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "All Decks"
    }
  
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        view = contentView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDeckCellModels()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewSource()
        configureNavigationbar()
        fetchDecks()
    }
    
    
    // MARK: Fetching decks
    func fetchDecks() {
        let request = Decks.FetchDecks.Request()
        interactor?.fetchDecks(request: request)
    }
    
    // MARK: Display
    
    var cellModels: [DecksCollectionViewCell.DeckCellModel] = []
    
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel) {
        cellModels = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
    
    func displayUpdatedDeckCellModels(viewModel: Decks.UpdateDeckCellModels.ViewModel) {
        cellModels = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
    
    func displayEditedDeckTitle(viewModel: Decks.EditDeckTitle.ViewModel) {
        cellModels[viewModel.deckIndexToUpdate].deckTitle = viewModel.newDeckTitle
        contentView.collectionView.reloadData()
    }
    
    func displayDeletedDeck(viewModel: Decks.DeleteDeck.ViewModel) {
        cellModels.remove(at: viewModel.indexOfDeckToRemove)
        contentView.collectionView.reloadData()
    }
    
    func updateDeckCellModels() {
        let request = Decks.UpdateDeckCellModels.Request()
        interactor?.updateDeckCellModels(request: request)
    }
    
    // MARK: Navigation
    
    func displayDeckDetail(deckInfoToPass: Deck) {
        router.dataStore?.deckInfoToPass = deckInfoToPass
        router.routeToDeckDetail()
        router.dataStore?.deckInfoToPass = nil
    }
    
    
}

// MARK: - Collection view methods

extension DecksViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecksCollectionViewCell.identifier, for: indexPath) as! DecksCollectionViewCell
        
        cell.configureWithModel(cellModels[indexPath.row])
        
        cell.handleTapDeckOptionsButton = { [weak self] in
            guard let self = self else { return }
            
            let request = Decks.ShowDeckOptions.Request(indexOfDeckToEditOrDelete: indexPath.row)
            self.interactor?.showDeckOptions(request: request)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let request = Decks.ShowDeck.Request(indexPathRow: indexPath.row)
        interactor?.decksViewHandleTapDeckCell(request: request)
    }
    
}


