//
//  DeckDetailCollectionViewCell.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/14/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class DeckDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCellView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    static let identifier = "DeckDetailCollectionCell"
    
    struct CardCellModel {
        let frontSide: String
        let backSide: String
    }
    
    let cardFrontSideView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let cardFrontSideLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        
        return label
    }()
    
    let cardFrontAndBackSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        
       return view
    }()
    
    let cardBackSideView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let cardBackSideLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: Setup
    
    func setup() {
        // adding subviews
        contentView.addSubview(cardFrontAndBackSeparator)
        cardFrontSideView.addSubview(cardFrontSideLabel)
        contentView.addSubview(cardFrontSideView)
        cardBackSideView.addSubview(cardBackSideLabel)
        contentView.addSubview(cardBackSideView)
        
        // autolayout constraint configuration
        NSLayoutConstraint.activate([
            // separator
            cardFrontAndBackSeparator.topAnchor.constraint(equalTo: self.topAnchor, constant: 45),
            cardFrontAndBackSeparator.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: 0.5),
            cardFrontAndBackSeparator.leftAnchor.constraint(equalTo: self.leftAnchor),
            cardFrontAndBackSeparator.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            // frontSideView
            cardFrontSideView.topAnchor.constraint(equalTo: self.topAnchor),
            cardFrontSideView.heightAnchor.constraint(equalToConstant: 40),
            cardFrontSideView.leftAnchor.constraint(equalTo: self.leftAnchor),
            cardFrontSideView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            // frontSideLabel
            cardFrontSideLabel.leftAnchor.constraint(equalTo: cardFrontSideView.leftAnchor, constant: 20),
            cardFrontSideLabel.rightAnchor.constraint(equalTo: cardFrontSideView.rightAnchor, constant: -20),
            cardFrontSideLabel.topAnchor.constraint(equalTo: cardFrontSideView.topAnchor, constant: 5),
            cardFrontSideLabel.bottomAnchor.constraint(equalTo: cardFrontSideView.bottomAnchor, constant: -5),
            
            // backSideView
            cardBackSideView.topAnchor.constraint(equalTo: cardFrontSideView.bottomAnchor),
            cardBackSideView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardBackSideView.leftAnchor.constraint(equalTo: cardFrontSideView.leftAnchor),
            cardBackSideView.rightAnchor.constraint(equalTo: cardFrontSideView.rightAnchor),
            
            // backSideLabel
            cardBackSideLabel.leftAnchor.constraint(equalTo: cardBackSideView.leftAnchor, constant: 20),
            cardBackSideLabel.rightAnchor.constraint(equalTo: cardBackSideView.rightAnchor, constant: -20),
            cardBackSideLabel.topAnchor.constraint(equalTo: cardBackSideView.topAnchor, constant: 5),
            cardBackSideLabel.bottomAnchor.constraint(equalTo: cardBackSideView.bottomAnchor, constant: -5)
        ])
        
        
    }
    
    func configureCellView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
    }
    
    // MARK: Display configuration
    
    func configureWithModel(_ model: CardCellModel) {
        cardFrontSideLabel.text = model.frontSide
        cardBackSideLabel.text = model.backSide
    }
}
