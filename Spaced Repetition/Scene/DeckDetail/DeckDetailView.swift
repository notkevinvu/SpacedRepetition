//
//  DeckDetailView.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/6/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

// 1) setup deckdetailview by adding init() and required init?(coder:) methods
// 2) go to deckdetailVC, add a "contentView" var which is of type DeckDetailView!
// 3) in the private setup() method, add "let view = DeckDetailView()" and "viewController.contentView = view"
// 4) set the view of the VC to the content view in the loadView() lifecycle method
// 5) put collection view methods in an extension of the deck detail VC, which should conform to the UICollectionViewFlowLayoutDelegate and UICollectionViewDataSource protocols
// 6) remember to set the delegate and data source of the contentView.collectionView to self in the deck detail VC (i.e. the delegate/data source of the DeckDetailView's collectionView should be DeckDetailViewController)

import UIKit


// MARK: DeckDetailDelegate
protocol DeckDetailViewDelegate: class {
    // class conformance is required for weak variables
    func deckDetailViewSelectStudyDeck(request: DeckDetail.StudyDeck.Request)
}

class DeckDetailView: UIView {
    
    // MARK: Properties
    typealias Delegate = DeckDetailViewDelegate
    weak var delegate: Delegate?
    
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 360, height: 140)
        // bottom inset allows users to scroll to see last card if there are more
        // than 4 cards
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DeckDetailCollectionViewCell.self, forCellWithReuseIdentifier: DeckDetailCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    
    let studyDeckButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Study Deck", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        
        let studyDeckButtonColor = UIColor(hex: "3399fe")
        button.backgroundColor = studyDeckButtonColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleTapStudyDeckButton), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: Methods
    
    @objc func handleTapStudyDeckButton() {
        let request = DeckDetail.StudyDeck.Request()
        delegate?.deckDetailViewSelectStudyDeck(request: request)
    }
    
    
    // MARK: Object lifecycle

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupSubViews() {
        
        // Adding subviews
        addSubview(collectionView)
        addSubview(studyDeckButton)
        
        NSLayoutConstraint.activate([
            // collection view
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            
            // study deck button
            studyDeckButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35),
            studyDeckButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -35),
            studyDeckButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            studyDeckButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
}
