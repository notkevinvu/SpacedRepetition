//
//  DecksViewController.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

protocol DecksDisplayLogic: class {
    // TODO: REMOVE
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel)
    
    func displayDeckDetail(deckInfoToPass: NaiveDeck)
    
    
    
    
    func displayFetchedCDDecks(viewModel: CDDecks.FetchDecks.ViewModel)
    
    func displayCDDeckDetail(deckInfoToPass: Deck)
}

class DecksViewController: UIViewController, DecksDisplayLogic {
    
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
        // TODO: REMOVE WHEN FINISHED PORTING ALL METHODS TO CORE DATA
//        fetchDecksOnLoad()
        
        /*
         move fetch to viewDidLoad to fetch only once and reload data when we come
         back? how to reload data if it's 'local'? (i.e. since we use a local array
         cellModels, it needs to get updated if we delete decks; however, because
         we currently delete decks from the deck detail scene, how should we delete
         the deck from cellModels from there?)
         
         possible solution: create a bar button item to enable editing on all visible
         cells which includes editing title and deleting deck and this allows
         us to reload data in viewWillAppear instead of fetching each time
         */
        
        fetchCDDecksOnLoad()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewSource()
        configureNavigationbar()
    }
    
    
    
    
    
    
    
    // MARK: Core Data stuff
    
    func fetchCDDecksOnLoad() {
        let request = CDDecks.FetchDecks.Request()
        interactor?.fetchCDDecks(request: request)
    }
    
    // MARK: Display
    
    func displayFetchedCDDecks(viewModel: CDDecks.FetchDecks.ViewModel) {
        cellModels = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
    
    // MARK: Navigation
    
    func displayCDDeckDetail(deckInfoToPass: Deck) {
        router.dataStore?.cdDeckInfoTopass = deckInfoToPass
        router.routeToCDDeckDetail()
        router.dataStore?.cdDeckInfoTopass = nil
    }
    
    
    
    
    
    
    
    // MARK: Fetching Decks

    func fetchDecksOnLoad() {
        let request = Decks.FetchDecks.Request()
        interactor?.fetchDecks(request: request)
    }
  
    // MARK: Display
    
    var cellModels: [DecksCollectionViewCell.DeckCellModel] = []
    
    // NOT IN USE
    // TODO: REMOVE AFTER PORTING ALL METHODS TO CORE DATA
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel) {
        cellModels = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
  
    // MARK: User Interaction
  
    // MARK: Navigation
    
    func displayDeckDetail(deckInfoToPass: NaiveDeck) {
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: REMOVE AFTER PORTING ALL METHODS TO CORE DATA
//        let request = Decks.ShowDeck.Request(indexPathRow: indexPath.row)
//        interactor?.decksViewHandleTapDeckCell(request: request)
        
        let request = CDDecks.ShowDeck.Request(indexPathRow: indexPath.row)
        interactor?.decksViewHandleTapCDDeckCell(request: request)
    }
    
}


