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
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Object lifecycle
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setupSubviews() {
//        addGestureRecognizer(dismissVCTapGesture)
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    
    // MARK: Methods
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Call delegate method only if the touch is not within the container view
        // i.e. the background
        guard touch.view != containerView else { return }
        
        delegate?.didTapBackgroundToDismissVC()
    }

}
