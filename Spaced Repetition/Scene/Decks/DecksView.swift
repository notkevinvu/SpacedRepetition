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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 350, height: 100))
        // TODO: Style it to designs
        button.layer.borderWidth = 2
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
        
        addDeckButton.translatesAutoresizingMaskIntoConstraints = false
        let addDeckHorizontalAnchor = addDeckButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let addDeckLeftAnchor = addDeckButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        let addDeckRightAnchor = addDeckButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50)
        let addDeckBottomAnchor = addDeckButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60)
        let addDeckHeightAnchor = addDeckButton.heightAnchor.constraint(equalToConstant: 70)
        self.addConstraints([addDeckHorizontalAnchor, addDeckLeftAnchor, addDeckRightAnchor, addDeckBottomAnchor, addDeckHeightAnchor])
    }
    
    @objc private func handleAddDeck() {
        delegate?.decksViewSelectAddDeck()
        print("Button tapped")
    }
    
}
