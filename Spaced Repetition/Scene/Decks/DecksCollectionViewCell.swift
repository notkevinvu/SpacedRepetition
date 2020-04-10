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
    
    var deckTitleLabel: UILabel = {
        let deckTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        deckTitleLabel.font = UIFont.boldSystemFont(ofSize: 27)
//        deckTitleLabel.layer.borderWidth = 0.5
        deckTitleLabel.textAlignment = .left
        return deckTitleLabel
    }()
    
    var deckOptionsButton: UIButton = {
        let deckOptionsButton = UIButton()
        deckOptionsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        deckOptionsButton.tintColor = .black
        
        return deckOptionsButton
    }()
    
    var numOfCardsLabel: UILabel = {
        let numOfCardsLabel = UILabel(frame: CGRect.zero)
        numOfCardsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numOfCardsLabel.textColor = .gray
//        numOfCardsLabel.layer.borderWidth = 0.5
        numOfCardsLabel.textAlignment = .left
        
        return numOfCardsLabel
    }()
    
    var reviewNotificationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.cornerRadius = 5
        label.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        label.textAlignment = .left
        label.text = "Needs Review"
        // TODO: Need to provide insets, may have to subclass UILabel and override the drawText(in:) method
        
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup subviews
    
    func setup() {
        // MARK: Title label
        contentView.addSubview(deckTitleLabel)
        deckTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelLeftAnchor = deckTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        let titleLabelRightAnchor = deckTitleLabel.rightAnchor.constraint(equalTo: deckOptionsButton.leftAnchor, constant: -10)
        let titleLabelTopAnchor = deckTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let titleLabelHeightAnchor = deckTitleLabel.heightAnchor.constraint(equalToConstant: 30)
        
        // MARK: Deck options button
        contentView.addSubview(deckOptionsButton)
        deckOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        let optionsWidthAnchor = deckOptionsButton.widthAnchor.constraint(equalToConstant: 25)
        let optionsHeightAnchor = deckOptionsButton.heightAnchor.constraint(equalToConstant: 25)
        let optionsTopAnchor = deckOptionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 18)
        let optionsRightAnchor = deckOptionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        
        // MARK: Card # label
        contentView.addSubview(numOfCardsLabel)
        numOfCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        let cardsLabelLeftAnchor = numOfCardsLabel.leftAnchor.constraint(equalTo: deckTitleLabel.leftAnchor)
        let cardsLabelWidthAnchor = numOfCardsLabel.widthAnchor.constraint(equalToConstant: 100)
        let cardsLabelTopAnchor = numOfCardsLabel.topAnchor.constraint(equalTo: deckTitleLabel.bottomAnchor)
        let cardsLabelHeightAnchor = numOfCardsLabel.heightAnchor.constraint(equalToConstant: 25)
        
        // MARK: review label
        contentView.addSubview(reviewNotificationLabel)
        reviewNotificationLabel.translatesAutoresizingMaskIntoConstraints = false
        let reviewLabelLeftAnchor = reviewNotificationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let reviewLabelRightAnchor = reviewNotificationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        let reviewLabelBottomAnchor = reviewNotificationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        let reviewLabelHeightAnchor = reviewNotificationLabel.heightAnchor.constraint(equalToConstant: 30)
        
        NSLayoutConstraint.activate([
        // title label
            titleLabelLeftAnchor,
            titleLabelRightAnchor,
            titleLabelTopAnchor,
            titleLabelHeightAnchor,
        
        // options button
            optionsWidthAnchor,
            optionsHeightAnchor,
            optionsTopAnchor,
            optionsRightAnchor,
        
        // number of cards label
            cardsLabelLeftAnchor,
            cardsLabelWidthAnchor,
            cardsLabelTopAnchor,
            cardsLabelHeightAnchor,
            
        // review label
            reviewLabelLeftAnchor,
            reviewLabelRightAnchor,
            reviewLabelBottomAnchor,
            reviewLabelHeightAnchor
        ])
    }
    
    func configureCardView() {
        
    }

}
