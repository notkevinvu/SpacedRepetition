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
  
    // MARK: View lifecycle
    
    override func loadView() {
        view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func displayFetchedDecks(viewModel: Decks.FetchDecks.ViewModel) {
        contentView.displayedDecks = viewModel.displayedDecks
        print("\(viewModel.displayedDecks[1].nameOfDeck)")
        contentView.tableView.reloadData()
    }
    
    func displayDeckDetail() {
        router.routeToDeckDetail()
    }
  
    // MARK: User Interaction
  
    // MARK: Navigation
  
}


