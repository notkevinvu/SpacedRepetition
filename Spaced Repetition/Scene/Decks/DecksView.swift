//
//  DecksView.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

protocol DecksViewDelegate: class {
    func decksViewSelectAddDeck()
}

final class DecksView: UIView {
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DecksCollectionViewCell.self, forCellWithReuseIdentifier: "decksCell")
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    typealias Delegate = DecksViewDelegate
    
    private lazy var addDeckButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 350, height: 100))
        // TODO: Style it to designs
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleAddDeck), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: Delegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
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
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 360, height: 110)
        
        collectionView.collectionViewLayout = layout
        
        // MARK: add deck button setup
        addDeckButton.backgroundColor = UIColor.white
        addSubview(addDeckButton)
        
        addDeckButton.translatesAutoresizingMaskIntoConstraints = false
        let addDeckHorizontalAnchor = addDeckButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let addDeckLeftAnchor = addDeckButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        let addDeckRightAnchor = addDeckButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50)
        let addDeckBottomAnchor = addDeckButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        let addDeckHeightAnchor = addDeckButton.heightAnchor.constraint(equalToConstant: 70)
        self.addConstraints([
            addDeckHorizontalAnchor,
            addDeckLeftAnchor,
            addDeckRightAnchor,
            addDeckBottomAnchor,
            addDeckHeightAnchor
        ])
        addDeckButton.layer.shadowOffset = .zero
        addDeckButton.layer.shadowRadius = 7
        addDeckButton.layer.shadowOpacity = 0.2
        addDeckButton.layer.cornerRadius = 7
        addDeckButton.setTitle("+ Add Deck", for: .normal)
        addDeckButton.setTitleColor(.black, for: .normal)
        
        
    }
    
    @objc private func handleAddDeck() {
        delegate?.decksViewSelectAddDeck()
    }
    
}
