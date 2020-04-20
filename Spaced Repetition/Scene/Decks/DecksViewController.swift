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
        // why do we use navigationitem.title instead of navigationController.title?
        navigationItem.title = "All Decks"
    }
  
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDecksOnLoad()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewSource()
        configureNavigationbar()
    }
    
    // MARK: Fetching Decks
    
    func fetchDecksOnLoad() {
        // starting with VC, make a request to send to the interactor
        let request = Decks.FetchDecks.Request()
        interactor?.fetchDecks(request: request)
    }
  
    // MARK: Display
    
    var cellModels: [DecksCollectionViewCell.DeckCellModel] = []
    
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel) {
        cellModels = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
  
    // MARK: User Interaction
  
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let request = Decks.ShowDeck.Request(indexPathRow: indexPath.row)
        interactor?.decksViewHandleTapDeckCell(request: request)
        
    }
    
}


