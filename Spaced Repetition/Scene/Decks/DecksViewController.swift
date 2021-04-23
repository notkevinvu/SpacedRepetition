//
//  DecksViewController.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright (c) 2020 An Nguyen All rights reserved.
//

import UIKit

// TODO: Add a search function for deck title, review flags

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = DecksInteractor(factory: DependencyContainer())
        let presenter = DecksPresenter()
        let router = DecksRouter()
        let contentView = DecksView(view: view)
        
        viewController.interactor = interactor
        viewController.router = router
        viewController.contentView = contentView
        interactor.presenter = presenter
        presenter.viewController = viewController
        presenter.alertDisplayableViewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        contentView.delegate = interactor
    }
    
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.collectionView.dragDelegate = self
        contentView.collectionView.dropDelegate = self
    }
    
    private func configureNavigationbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "All Decks"
    }
  
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        setup()
        view = contentView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDeckCellModels()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationbar()
        fetchDecks()
    }
    
    
    // MARK: Fetching/updating decks
    func fetchDecks() {
        let request = Decks.FetchDecks.Request()
        interactor?.fetchDecks(request: request)
    }
    
    func updateDeckCellModels() {
        let request = Decks.UpdateDeckCellModels.Request()
        interactor?.updateDeckCellModels(request: request)
    }
    
    // MARK: Display logic
    
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
    
    // MARK: Navigation
    func displayDeckDetail(deckInfoToPass: Deck) {
        router.dataStore?.deckInfoToPass = deckInfoToPass
        router.routeToDeckDetail()
        router.dataStore?.deckInfoToPass = nil
    }
    
    
    // MARK: Helper methods
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        guard
            let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath
            else {
                return
        }
        
        collectionView.performBatchUpdates({
            let cellModelToMove = cellModels.remove(at: sourceIndexPath.item)
            cellModels.insert(cellModelToMove, at: destinationIndexPath.item)
            
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        }, completion: nil)
        
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        
        let request = Decks.ReorderDeck.Request(sourceIndex: sourceIndexPath.item, destinationIndex: destinationIndexPath.item)
        interactor?.reorderDeck(request: request)
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
    
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let temp = cellModels.remove(at: sourceIndexPath.item)
//        cellModels.insert(temp, at: destinationIndexPath.item)
//        print("Origin indexpath: \(sourceIndexPath.item) - destination: \(destinationIndexPath.item)")
//
//        // TODO: Re-implement this if we want to use the long press gesture method
//    }
    
}

// MARK: Drag/drop collection view ext
extension DecksViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = cellModels[indexPath.row]
        
        let itemProvider = NSItemProvider(object: item.deckTitle as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        
    }
    
    
    
    
}



