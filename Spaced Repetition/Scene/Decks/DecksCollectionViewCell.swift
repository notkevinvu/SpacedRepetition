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
        deckTitleLabel.font = UIFont.systemFont(ofSize: 30.0)
        deckTitleLabel.layer.borderWidth = 0.5
        deckTitleLabel.layer.borderColor = UIColor.black.cgColor
        deckTitleLabel.textAlignment = .left
        return deckTitleLabel
    }()
    
    var deckOptionsButton: UIButton = {
        let deckOptionsButton = UIButton()
        deckOptionsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        deckOptionsButton.tintColor = .black
        
        return deckOptionsButton
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
        contentView.addSubview(deckTitleLabel)
        
        deckTitleLabel.font = UIFont.systemFont(ofSize: 26)
        deckTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelLeftAnchor = deckTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let titleLabelRightAnchor = deckTitleLabel.rightAnchor.constraint(equalTo: deckOptionsButton.leftAnchor, constant: -10)
        let titleLabelTopAnchor = deckTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let titleLabelHeightAnchor = deckTitleLabel.heightAnchor.constraint(equalToConstant: 30)
        
        contentView.addSubview(deckOptionsButton)
        
        deckOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        let optionsWidthAnchor = deckOptionsButton.widthAnchor.constraint(equalToConstant: 25)
        let optionsHeightAnchor = deckOptionsButton.heightAnchor.constraint(equalToConstant: 25)
        let optionsTopAnchor = deckOptionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let optionsRightAnchor = deckOptionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
        titleLabelLeftAnchor,
        titleLabelRightAnchor,
        titleLabelTopAnchor,
        titleLabelHeightAnchor
        ])
        NSLayoutConstraint.activate([
        optionsWidthAnchor,
        optionsHeightAnchor,
        optionsTopAnchor,
        optionsRightAnchor
        ])
    }
    
    func configureCardView() {
        
    }

}
