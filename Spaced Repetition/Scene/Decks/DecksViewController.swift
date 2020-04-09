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
    
    func displayDeckDetail()
}

class DecksViewController: UIViewController, DecksDisplayLogic {
    
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
        let interactor = DecksInteractor()
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
        view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewSource()
        configureNavigationbar()
        fetchDecksOnLoad()
    }
    
    // MARK: Fetching Decks
    
    func fetchDecksOnLoad() {
        // starting with VC, make a request to send to the interactor
        let request = Decks.FetchDecks.Request()
        interactor?.fetchDecks(request: request)
    }
    
    // MARK: Properties
  
  
    // MARK: Display
    
    var displayedDecks: [Deck] = []
    
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel) {
        displayedDecks = viewModel.displayedDecks
        contentView.collectionView.reloadData()
    }
  
    // MARK: User Interaction
  
    // MARK: Navigation
    
    func displayDeckDetail() {
        router.routeToDeckDetail()
    }
    
}

// MARK: - Collection view methods

extension DecksViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedDecks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "decksCell", for: indexPath) as! DecksCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        
        cell.layer.shadowRadius = 8
        cell.layer.shadowOffset = .zero
        cell.layer.shadowOpacity = 0.25
        
        // probably need to make a custom collection view cell to contain a:
        // 1) Deck title label
        // 2) # of cards label
        // 3) settings/options gear button
        // 4) needs review/up to date label
        cell.deckTitleLabel.text = "\(displayedDecks[indexPath.row].nameOfDeck)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped cell: \(indexPath.row)")
    }
    
}


