//
//  DecksView.swift
//  Spaced Repetition
//
//  Created by An Nguyen on 3/24/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

protocol DecksViewDelegate: class {
    func decksViewSelectAddDeck()
}

final class DecksView: UIView {
    
    typealias Delegate = DecksViewDelegate
    
    private lazy var addDeckButton: UIButton = {
        let button = UIButton()
        // TODO: Style it to designs
        button.addTarget(self, action: #selector(handleAddDeck), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: Delegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(addDeckButton)
        
        // TODO: Setup constraints on the views inside here
    }
    
    @objc private func handleAddDeck() {
        delegate?.decksViewSelectAddDeck()
    }
    
}
