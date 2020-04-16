//
//  DecksView.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

protocol DecksViewDelegate: class {
    func decksViewSelectAddDeck(request: Decks.CreateDeck.Request)
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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DecksCollectionViewCell.self, forCellWithReuseIdentifier: DecksCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
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
        addDeckButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addDeckButton.translatesAutoresizingMaskIntoConstraints = false
        
        addDeckButton.addTarget(self, action: #selector(handleAddDeck), for: .touchUpInside)
        return addDeckButton
    }()
    
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
        
        // Collection view setup
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // collection view
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            ])
            
            // Add deck button setup
            addSubview(addDeckButton)
            NSLayoutConstraint.activate([
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
        delegate?.decksViewSelectAddDeck(request: request)
    }
    
}
