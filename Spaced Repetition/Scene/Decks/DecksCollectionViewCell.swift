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
    
    var handleTapDeckOptionsButton: (() -> ())?
    
    struct DeckCellModel {
        var deckTitle: String
        let numberOfCards: Int
        let needsReview: Bool?
    }
    
    let deckTitleLabel: UILabel = {
        let deckTitleLabel = UILabel(frame: CGRect.zero)
        deckTitleLabel.font = UIFont.boldSystemFont(ofSize: 27)
        deckTitleLabel.textAlignment = .left
        deckTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return deckTitleLabel
    }()
    
    lazy var deckOptionsButton: UIButton = {
        let deckOptionsButton = UIButton()
        deckOptionsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        deckOptionsButton.tintColor = .black
        deckOptionsButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        deckOptionsButton.layer.cornerRadius = 5
        deckOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        deckOptionsButton.addTarget(self, action: #selector(didTapDeckOptionsButton), for: .touchUpInside)
        
        return deckOptionsButton
    }()
    
    let numOfCardsLabel: UILabel = {
        let numOfCardsLabel = UILabel(frame: CGRect.zero)
        numOfCardsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numOfCardsLabel.textColor = .gray
        numOfCardsLabel.textAlignment = .left
        numOfCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return numOfCardsLabel
    }()
    
    let reviewNotificationView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let reviewNotificationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = "Needs Review"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let reviewNotificationImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "hourglass")!
        imageView.image = image
        imageView.tintColor = .black
        
        return imageView
    }()
    
    // MARK: Object Lifecycle
    
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
        contentView.addSubview(reviewNotificationView)
        reviewNotificationView.addSubview(reviewNotificationLabel)
        reviewNotificationView.addSubview(reviewNotificationImageView)
        
        
        NSLayoutConstraint.activate([
            
            deckTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            deckTitleLabel.rightAnchor.constraint(equalTo: deckOptionsButton.leftAnchor, constant: -10),
            deckTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            deckTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            deckOptionsButton.widthAnchor.constraint(equalToConstant: 35),
            deckOptionsButton.heightAnchor.constraint(equalToConstant: 35),
            deckOptionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            deckOptionsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            
            numOfCardsLabel.leftAnchor.constraint(equalTo: deckTitleLabel.leftAnchor),
            numOfCardsLabel.widthAnchor.constraint(equalToConstant: 100),
            numOfCardsLabel.topAnchor.constraint(equalTo: deckTitleLabel.bottomAnchor),
            numOfCardsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            reviewNotificationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            reviewNotificationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            reviewNotificationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            reviewNotificationView.heightAnchor.constraint(equalToConstant: 30),
            
            reviewNotificationLabel.leftAnchor.constraint(equalTo: reviewNotificationView.leftAnchor, constant: 10),
            reviewNotificationLabel.rightAnchor.constraint(equalTo: reviewNotificationView.rightAnchor, constant: -30),
            reviewNotificationLabel.topAnchor.constraint(equalTo: reviewNotificationView.topAnchor),
            reviewNotificationLabel.bottomAnchor.constraint(equalTo: reviewNotificationView.bottomAnchor),
            
            reviewNotificationImageView.leftAnchor.constraint(equalTo: reviewNotificationLabel.rightAnchor, constant: 5),
            reviewNotificationImageView.rightAnchor.constraint(equalTo: reviewNotificationView.rightAnchor, constant: -5),
            reviewNotificationImageView.topAnchor.constraint(equalTo: reviewNotificationView.topAnchor, constant: 2.5),
            reviewNotificationImageView.bottomAnchor.constraint(equalTo: reviewNotificationView.bottomAnchor, constant: -2.5)
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
        
        guard let deckNeedsReview = model.needsReview else { return }
        switch deckNeedsReview {
        case true:
            if numOfCardsLabel.text == "0 Cards" {
                reviewNotificationLabel.text = "No cards yet!"
            } else {
                reviewNotificationLabel.text = "Needs review"
            }
        case false:
            reviewNotificationLabel.text = "All caught up!"
        }
    }
    
    
    // MARK: Button methods
    
    @objc func didTapDeckOptionsButton() {
        handleTapDeckOptionsButton?()
    }

}
