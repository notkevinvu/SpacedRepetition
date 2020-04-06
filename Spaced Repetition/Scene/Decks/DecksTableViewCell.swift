//
//  DecksTableViewCell.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class DecksTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var deckCardView = UIView()
    
    var deckTitleLabel: UILabel = {
        let deckTitleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
        deckTitleLabel.layer.borderWidth = 0.5
        deckTitleLabel.layer.borderColor = UIColor.black.cgColor
        return deckTitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup subviews
    
    func setup() {
        addSubview(deckCardView)
        configureCardView()
        
        deckCardView.translatesAutoresizingMaskIntoConstraints = false
        let deckCardLeftAnchor = deckCardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        let deckCardRightAnchor = deckCardView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        let deckCardBottomAnchor = deckCardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        let deckCardTopAnchor = deckCardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        self.addConstraints([
        deckCardLeftAnchor,
        deckCardRightAnchor,
        deckCardBottomAnchor,
        deckCardTopAnchor
        ])
        
        deckCardView.addSubview(deckTitleLabel)
    }
    
    func configureCardView() {
        deckCardView.layer.borderWidth = 1
        deckCardView.layer.cornerRadius = 15
        deckCardView.layer.shadowOpacity = 1
        deckCardView.layer.shadowOffset = CGSize.zero
        deckCardView.layer.backgroundColor = UIColor.white.cgColor
    }

}
