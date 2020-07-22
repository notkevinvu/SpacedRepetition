//
//  ExpandedCardDetailView.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 7/20/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

protocol ExpandedCardDetailViewDelegate: class {
    func didTapBackgroundToDismissVC()
}

class ExpandedCardDetailView: UIView {
    
    // MARK: Properties
    
    typealias Delegate = ExpandedCardDetailViewDelegate
    weak var delegate: Delegate?
    
    // MARK: Views
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    let frontSideTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        // number of lines is 0 by default (no limit until frame ends)
        // scroll and user interaction enabled by default
        view.font = UIFont.boldSystemFont(ofSize: 24)
        view.isSelectable = false
        
        return view
    }()
    
    
    let cardFrontAndBackSideSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    
    let backSideTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 22)
        view.isSelectable = false
        
        return view
    }()
    
    
    // MARK: Object lifecycle
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(frontSideTextView)
        containerView.addSubview(cardFrontAndBackSideSeparator)
        containerView.addSubview(backSideTextView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 360),
            containerView.heightAnchor.constraint(equalToConstant: 360),
            
            cardFrontAndBackSideSeparator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            cardFrontAndBackSideSeparator.bottomAnchor.constraint(equalTo: cardFrontAndBackSideSeparator.topAnchor, constant: 0.5),
            cardFrontAndBackSideSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            cardFrontAndBackSideSeparator.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            frontSideTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            frontSideTextView.bottomAnchor.constraint(equalTo: cardFrontAndBackSideSeparator.topAnchor, constant: -10),
            frontSideTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            frontSideTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            
            backSideTextView.topAnchor.constraint(equalTo: cardFrontAndBackSideSeparator.bottomAnchor, constant: 15),
            backSideTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            backSideTextView.leftAnchor.constraint(equalTo: frontSideTextView.leftAnchor),
            backSideTextView.rightAnchor.constraint(equalTo: frontSideTextView.rightAnchor)
        ])
    }
    
    
    // MARK: Methods
    
    
    func configureExpandedCardWithCardText(frontSideText: String, backSideText: String) {
        frontSideTextView.text = frontSideText
        backSideTextView.text = backSideText
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Call delegate method only if the touch is not within the container view
        // i.e. the background
        guard touch.view != containerView else { return }
        
        delegate?.didTapBackgroundToDismissVC()
    }

}
