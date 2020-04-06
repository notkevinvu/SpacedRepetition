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

import UIKit

protocol DeckDetailViewDelegate {
    func deckDetailViewSelectStudyDeck()
}

class DeckDetailView: UIView {
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "deckDetailCell")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        
        // MARK: Collection view setup
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let collectionLeftAnchor = collectionView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let collectionRightAnchor = collectionView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let collectionBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let collectionTopAnchor = collectionView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        NSLayoutConstraint.activate([
        collectionLeftAnchor,
        collectionRightAnchor,
        collectionBottomAnchor,
        collectionTopAnchor
        ])
        
    }
    
}
