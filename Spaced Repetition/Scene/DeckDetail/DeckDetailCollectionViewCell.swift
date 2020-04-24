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
    
    var isDeleteButtonVisible: Bool = false
    // alternatively can use a callback for the deleteButton to tell the VC
    // that the button was tapped
//    var didTapDeleteButton: (() -> ())?
    weak var delegate: DeckDetailCollectionCellDelegate?
    
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
    
    
    /*
     lazy var to access self only after self fully initializes
     */
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 14 // should be half the height/width of the button
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        
        button.layer.borderWidth = 0.5
        button.backgroundColor = .red
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.isHidden = true
        
        return button
    }()
    
    lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer()
        longPress.delaysTouchesEnded = true
        longPress.addTarget(self, action: #selector(displayDeleteButton))
        
        return longPress
    }()
    
    
    // MARK: Setup
    
    private func setupSubviews() {
        contentView.addSubview(cardFrontAndBackSeparator)
        contentView.addSubview(cardFrontSideLabel)
        contentView.addSubview(cardBackSideLabel)
        contentView.addSubview(deleteButton)
        contentView.addGestureRecognizer(longPressGestureRecognizer)
        
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
            
            deleteButton.heightAnchor.constraint(equalToConstant: deleteButton.layer.cornerRadius * 2),
            deleteButton.widthAnchor.constraint(equalToConstant: deleteButton.layer.cornerRadius * 2),
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
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
    
    
    @objc func displayDeleteButton(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if deleteButton.isHidden {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func handleTapDeleteButton() {
//        didTapDeleteButton?()
        delegate?.deleteButtonTapped()
    }
    
    
}
