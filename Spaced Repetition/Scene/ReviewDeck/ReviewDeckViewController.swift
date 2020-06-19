//
//  StudyDeckViewController.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/24/20.
//  Copyright (c) 2020 An Nguyen. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReviewDeckDisplayLogic: class {
    func displayFirstCardToReview(viewModel: ReviewDeck.ConfigureData.ViewModel)
    
    func displayNextCardToReview(viewModel: ReviewDeck.MoveToNextCard.ViewModel)
    
    func displayFinishedReviewingDeck(viewModel: ReviewDeck.FinishedReviewingDeck.ViewModel)
}

class ReviewDeckViewController: UIViewController, ReviewDeckDisplayLogic, AlertDisplayableViewController
{
    var interactor: ReviewDeckBusinessLogic?
    var router: (NSObjectProtocol & ReviewDeckRoutingLogic & ReviewDeckDataPassing)?
    var contentView: ReviewDeckView!

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup()
    {
        let viewController = self
        let interactor = ReviewDeckInteractor()
        let presenter = ReviewDeckPresenter()
        let router = ReviewDeckRouter()
        let view = ReviewDeckView()
        
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
    
    private func configureDataAndSceneOnLoad() {
        let request = ReviewDeck.ConfigureData.Request()
        interactor?.sortCards(request: request)
    }
  
    // MARK: Routing
  
    
  
    // MARK: View lifecycle
    
    override func loadView() {
        view = contentView
    }
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureDataAndSceneOnLoad()
        setupNavigationBar()
    }
    
    // MARK: Nav bar setup
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        /*
         TODO: Eventually, it is preferable to change this button such that it
         uses a custom image/button (button should have its own image ofc) -
         (refer to the line above the current done bar button item that
         specifies a customView)
         */
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ourCustomView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    // MARK: Display Logic
    
    func displayFirstCardToReview(viewModel: ReviewDeck.ConfigureData.ViewModel) {
        contentView.configureCardView(cardModel: viewModel.cardToReviewCardModel)
        navigationItem.title = viewModel.nameOfDeckBeingReviewed
        
        guard let numOfCardsToReview = viewModel.numOfCardsToReview else {
            let request = ReviewDeck.NoCardsToReview.Request()
            interactor?.showNoCardsToReviewAlert(request: request)
            return
        }
        contentView.progress.totalUnitCount = Int64(numOfCardsToReview)
    }
    
    
    func displayNextCardToReview(viewModel: ReviewDeck.MoveToNextCard.ViewModel) {
        contentView.configureCardView(cardModel: viewModel.cardModelForNextCard)
    }
    
    
    func displayFinishedReviewingDeck(viewModel: ReviewDeck.FinishedReviewingDeck.ViewModel) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Button methods
    
    @objc func didTapDoneButton() {
        let request = ReviewDeck.FinishedReviewingDeck.Request()
        interactor?.showConfirmPopViewControllerAlert(request: request)
    }
  
    
}
