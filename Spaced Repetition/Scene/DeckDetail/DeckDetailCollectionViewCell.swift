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
    
    let cardFrontSideLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    let cardBackSideLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: Setup
    
    func setup() {
        // adding subviews
        
        // there are front and back UIViews so
        contentView.addSubview(cardFrontAndBackSeparator)
        contentView.addSubview(cardFrontSideLabel)
        contentView.addSubview(cardBackSideLabel)
        
        // autolayout constraint configuration
        NSLayoutConstraint.activate([
            // separator
            // the separator line should be ~50 points from the top of the collection cell
            // maybe switch from raw constant to collection cell height * 0.45?
            cardFrontAndBackSeparator.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            cardFrontAndBackSeparator.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: 0.5),
            cardFrontAndBackSeparator.leftAnchor.constraint(equalTo: self.leftAnchor),
            cardFrontAndBackSeparator.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            // frontSideLabel
            cardFrontSideLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cardFrontSideLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            cardFrontSideLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cardFrontSideLabel.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: -5),
            
            // backSideLabel
            cardBackSideLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cardBackSideLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            cardBackSideLabel.topAnchor.constraint(equalTo: cardFrontAndBackSeparator.bottomAnchor, constant: 5),
            cardBackSideLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
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
