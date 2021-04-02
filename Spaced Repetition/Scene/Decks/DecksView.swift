//
//  DecksView.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

protocol DecksViewDelegate: class {
    func decksViewHandleTapAddDeckButton(request: Decks.CreateDeck.Request)
}

final class DecksView: UIView {
    
    // MARK: Properties
    
    typealias Delegate = DecksViewDelegate
    weak var delegate: Delegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 360, height: 110)
        // bottom edge inset added to allow users to scroll up more to see last deck
        // if there are more than 4 decks
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DecksCollectionViewCell.self, forCellWithReuseIdentifier: DecksCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // give collection view a bit more space at top from the title/nav bar
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.dragInteractionEnabled = true
        
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }()
    
    
    private lazy var addDeckButton: UIButton = {
        let addDeckButton = UIButton(frame: CGRect(x: 0, y: 0, width: 350, height: 100))
        // TODO: Style it to designs
        addDeckButton.layer.shadowOffset = .zero
        addDeckButton.layer.shadowRadius = 7
        addDeckButton.layer.shadowOpacity = 0.2
        addDeckButton.layer.cornerRadius = 7
        addDeckButton.backgroundColor = .white
        addDeckButton.setTitle("+ Add Deck", for: .normal)
        addDeckButton.setTitleColor(.black, for: .normal)
        addDeckButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        addDeckButton.translatesAutoresizingMaskIntoConstraints = false
        
        addDeckButton.addTarget(self, action: #selector(handleAddDeck), for: .touchUpInside)
        return addDeckButton
    }()
    
    
    /*
     TODO: If we don't want to use the UICollectionViewDragDelegate method of
     reordering cells, we should add the longPressGesture back in
     
     The reason we are not using it is because it has a slight bug where the
     cell being dragged will snap back to its original position temporarily
     if it gets close to the original position. It will then snap back to the
     user's touch point
     */
    
//    private lazy var longPressGesture: UILongPressGestureRecognizer = {
//        let lp = UILongPressGestureRecognizer()
//        lp.addTarget(self, action: #selector(didLongPressCollectionView(sender:)))
//
//        return lp
//    }()

    
    // MARK: Object lifecycle
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupSubviews() {
        
        addSubview(collectionView)
        addSubview(addDeckButton)
        // TODO: Add this back in if not using UICollectionViewDragDelegate
//        collectionView.addGestureRecognizer(longPressGesture)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            
            addDeckButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addDeckButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50),
            addDeckButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50),
            addDeckButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            addDeckButton.heightAnchor.constraint(equalToConstant: 70)
            ])
        
    }
    
    // MARK: Methods
    
    @objc private func handleAddDeck() {
        let request = Decks.CreateDeck.Request()
        delegate?.decksViewHandleTapAddDeckButton(request: request)
    }
    
    // TODO: Add this back in if not using UICollectionViewDragDelegate
    
//    @objc private func didLongPressCollectionView(sender: UILongPressGestureRecognizer) {
//        switch sender.state {
//        case .began:
//            guard let selectedIndexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else { break }
//            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case .changed:
//            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
//        case .ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }
}
