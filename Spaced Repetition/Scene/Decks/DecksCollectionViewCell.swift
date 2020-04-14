//
//  DecksTableViewCell.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class DecksCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    /*
     this is to avoid "stringly" code - when we register and dequeue a cell,
     instead of putting in the string identifier, we can simply use the
     static identifier as the identifier string (e.g.
     identifier: DecksCollectionViewCell.identifier - which should get
     autocompleted)
     */
    static let identifier = "DeckCollectionCell"
    
    struct DeckCellModel {
        let deckTitle: String
        let numberOfCards: Int
    }
    
    var deckTitleLabel: UILabel = {
        let deckTitleLabel = UILabel(frame: CGRect.zero)
        deckTitleLabel.font = UIFont.boldSystemFont(ofSize: 27)
        deckTitleLabel.textAlignment = .left
        deckTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return deckTitleLabel
    }()
    
    var deckOptionsButton: UIButton = {
        let deckOptionsButton = UIButton()
        deckOptionsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        deckOptionsButton.tintColor = .black
        deckOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        return deckOptionsButton
    }()
    
    var numOfCardsLabel: UILabel = {
        let numOfCardsLabel = UILabel(frame: CGRect.zero)
        numOfCardsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numOfCardsLabel.textColor = .gray
        numOfCardsLabel.textAlignment = .left
        numOfCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return numOfCardsLabel
    }()
    
    var reviewNotificationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.cornerRadius = 5
        label.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        label.textAlignment = .left
        label.text = "Needs Review"
        label.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Need to provide insets, may have to subclass UILabel and override the drawText(in:) method
        
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCellView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup subviews
    
    func setup() {
        // adding subviews
        contentView.addSubview(deckTitleLabel)
        contentView.addSubview(deckOptionsButton)
        contentView.addSubview(numOfCardsLabel)
        contentView.addSubview(reviewNotificationLabel)
        
        // configuring autolayout constraints
        NSLayoutConstraint.activate([
        // title label
        deckTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        deckTitleLabel.rightAnchor.constraint(equalTo: deckOptionsButton.leftAnchor, constant: -10),
        deckTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        deckTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
        // options button
        deckOptionsButton.widthAnchor.constraint(equalToConstant: 25),
        deckOptionsButton.heightAnchor.constraint(equalToConstant: 25),
        deckOptionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
        deckOptionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            
        // number of cards label
        numOfCardsLabel.leftAnchor.constraint(equalTo: deckTitleLabel.leftAnchor),
        numOfCardsLabel.widthAnchor.constraint(equalToConstant: 100),
        numOfCardsLabel.topAnchor.constraint(equalTo: deckTitleLabel.bottomAnchor),
        numOfCardsLabel.heightAnchor.constraint(equalToConstant: 25),
            
        // review label
        reviewNotificationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        reviewNotificationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        reviewNotificationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        reviewNotificationLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureCellView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
    }
    
    // MARK: Display Configuration
    func configureWithModel(_ model: DeckCellModel) {
        deckTitleLabel.text = model.deckTitle
        numOfCardsLabel.text = "\(model.numberOfCards) Cards"
    }

}
