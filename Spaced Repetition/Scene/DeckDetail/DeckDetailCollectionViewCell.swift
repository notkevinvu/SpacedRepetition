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
    
    // callback functions to tell VC that a button was tapped
    var didTapEditButton: (() -> ())?
    var didTapDeleteButton: (() -> ())?
    
    
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
    
    
    lazy var editButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "a4dced")
        button.layer.cornerRadius = self.layer.cornerRadius
        button.layer.maskedCorners = [.layerMaxXMinYCorner]
        button.layer.borderWidth = 0.5
        
        button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(handleTapEditButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    // used to animate the button in
    var editButtonWidthAnchor: NSLayoutConstraint?
    
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "eb8888")
        button.layer.cornerRadius = self.layer.cornerRadius
        button.layer.maskedCorners = [.layerMaxXMaxYCorner]
        button.layer.borderWidth = 0.5
        
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(handleTapDeleteButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    var deleteButtonWidthAnchor: NSLayoutConstraint?
    
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(toggleEditViews))
        
        return tap
    }()
    
    
    // MARK: Setup
    
    private func setupSubviews() {
        contentView.addSubview(cardFrontAndBackSeparator)
        contentView.addSubview(cardFrontSideLabel)
        contentView.addSubview(cardBackSideLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(editButton)
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
        editButtonWidthAnchor = editButton.widthAnchor.constraint(equalToConstant: 0)
        // activate here so we don't need to unwrap in the .activate() method
        editButtonWidthAnchor?.isActive = true
        deleteButtonWidthAnchor = deleteButton.widthAnchor.constraint(equalToConstant: 0)
        deleteButtonWidthAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            cardFrontAndBackSeparator.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            cardFrontAndBackSeparator.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: 0.5),
            cardFrontAndBackSeparator.leftAnchor.constraint(equalTo: self.leftAnchor),
            cardFrontAndBackSeparator.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            
            cardFrontSideLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cardFrontSideLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            cardFrontSideLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cardFrontSideLabel.bottomAnchor.constraint(equalTo: cardFrontAndBackSeparator.topAnchor, constant: -5),
            
            
            cardBackSideLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cardBackSideLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            cardBackSideLabel.topAnchor.constraint(equalTo: cardFrontAndBackSeparator.bottomAnchor, constant: 5),
            cardBackSideLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            editButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            editButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            editButton.topAnchor.constraint(equalTo: self.topAnchor),
            
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            deleteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    
    private func configureCellView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
    }
    
    
    // MARK: Display configuration
    
    public func configureWithModel(_ model: CardCellModel) {
        cardFrontSideLabel.text = model.frontSide
        cardBackSideLabel.text = model.backSide
    }
    
    @objc func toggleEditViews() {
        if editButtonWidthAnchor?.constant == 0 {
            
            editButtonWidthAnchor?.constant = 80
            deleteButtonWidthAnchor?.constant = 80
        } else {
            editButtonWidthAnchor?.constant = 0
            deleteButtonWidthAnchor?.constant = 0
        }
        
        UIView.animate(withDuration: 0.2) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Methods
    
    @objc func handleTapEditButton(sender: UIButton) {
        didTapEditButton?()
    }
    
    @objc func handleTapDeleteButton(sender: UIButton) {
        didTapDeleteButton?()
    }
    
    
}
