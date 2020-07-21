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
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    static let identifier = "DeckDetailCollectionCell"
    
    // callback variable to tell VC that a button was tapped
    var didTapOptionsButton: ( () -> () )?
    
    struct CardCellModel {
        let frontSide: String
        let backSide: String
    }
    
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
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
        label.numberOfLines = 0
        
        return label
    }()
    
    
    lazy var cardOptionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleTapOptionsButton), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        // TODO: tap gesture should present an expanded card view (do this in
        // view controller in didSelectItemAt
        
        return tap
    }()
    
    
    // MARK: Setup
    
    private func configureCellView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(cardFrontAndBackSeparator)
        containerView.addSubview(cardFrontSideLabel)
        containerView.addSubview(cardBackSideLabel)
        containerView.addSubview(cardOptionsButton)
        
        // TODO: Uncomment this back in if we still want to use a tap gesture
        // instead of using didSelectItemAt in the VC
//        containerView.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            cardFrontAndBackSeparator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            cardFrontAndBackSeparator.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: 0.5),
            cardFrontAndBackSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            cardFrontAndBackSeparator.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            
            cardOptionsButton.centerXAnchor.constraint(equalTo: containerView.rightAnchor, constant: -25),
            cardOptionsButton.centerYAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: -25),
            cardOptionsButton.heightAnchor.constraint(equalToConstant: 30),
            cardOptionsButton.widthAnchor.constraint(equalToConstant: 30),
            
            
            cardFrontSideLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            cardFrontSideLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            cardFrontSideLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            cardFrontSideLabel.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: -5),
            
            
            cardBackSideLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            cardBackSideLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            cardBackSideLabel.topAnchor.constraint(equalTo: cardFrontAndBackSeparator.bottomAnchor, constant: 5),
            cardBackSideLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
        
    }
    
    
    // MARK: Display configuration
    
    public func configureWithModel(_ model: CardCellModel) {
        cardFrontSideLabel.text = model.frontSide
        cardBackSideLabel.text = model.backSide
    }
    
    
    // MARK: - Button Methods
    
    /*
     - when user taps button, handleTapOptionsButton() is called
     - handleTap...() then calls didTap...()
     - didTap...() is defined in the VC's collection view methods (cellForRowAt)
     and whatever is in that closure gets called
     */
    @objc func handleTapOptionsButton(sender: UIButton) {
        didTapOptionsButton?()
    }
    
    
}
