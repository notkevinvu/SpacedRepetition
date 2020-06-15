//
//  ReviewDeckView.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 6/13/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit


protocol ReviewDeckViewDelegate: class {
    func didTapDoneButton()
}

class ReviewDeckView: UIView {
    
    typealias Delegate = ReviewDeckViewDelegate
    weak var delegate: Delegate?
    
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup subviews
    
    private func setupSubviews() {
        
    }
    
    
    
}
