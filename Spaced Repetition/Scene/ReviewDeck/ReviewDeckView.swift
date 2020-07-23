//
//  ReviewDeckView.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 6/13/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit


protocol ReviewDeckViewDelegate: class {
    func didTapCorrectAnswerButton()
    func didTapWrongAnswerButton()
    
    func didFinishProgressBar()
}

class ReviewDeckView: UIView {
    
    typealias Delegate = ReviewDeckViewDelegate
    weak var delegate: Delegate?
    
    // MARK: Container view
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    // MARK: Progress bar
    lazy var currentProgressBarView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        // set corner radius for both progress bar and tracking bar view
        for subview in progressView.subviews {
            // cornerRadius is 1/2 the heightAnchor
            subview.layer.cornerRadius = 5
            subview.layer.masksToBounds = true
        }
        
        progressView.tintColor = .black
        
        return progressView
    }()
    
    lazy var progress: Progress = {
        let progress = Progress()
        return progress
    }()
    
    // MARK: Card view
    lazy var currentCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    
    let cardFrontSideTextView: UITextView = {
        let txtView = UITextView(frame: .zero)
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.textAlignment = .left
        txtView.backgroundColor = .clear
//        label.numberOfLines = 0
        txtView.isSelectable = false
        txtView.font = UIFont.boldSystemFont(ofSize: 26)
        
        return txtView
    }()
    
    let cardBackSideTextView: UITextView = {
        let txtView = UITextView(frame: .zero)
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.textAlignment = .left
        txtView.backgroundColor = .clear
//        label.numberOfLines = 0
        txtView.isSelectable = false
        txtView.font = UIFont.boldSystemFont(ofSize: 26)
        
        return txtView
    }()
    
    // MARK: Card model
    struct ReviewCardModel {
        let frontSideText: String
        let backSideText: String
    }
    
    lazy var cardViewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        // TODO: Maybe remove the card view tap gesture? Not sure yet
        gesture.addTarget(self, action: #selector(didTapFlipCardButton))
        
        return gesture
    }()
    
    // MARK: Flip card button
    lazy var flipCardButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(hex: "3399fe")
        btn.layer.cornerRadius = 7
        
        btn.setTitle("Flip Card", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        
        btn.addTarget(self, action: #selector(didTapFlipCardButton), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: Wrong answer button
    lazy var wrongAnswerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(didTapWrongAnswerButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    // MARK: Correct answer button
    lazy var correctAnswerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(didTapCorrectAnswerButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: config)
        button.setImage(checkmarkImage, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    lazy var buttonSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup subviews
    
    private func setupSubviews() {
        
        backgroundColor = .white
        
        addSubview(containerView)
        
        containerView.addSubview(currentProgressBarView)
        
        containerView.addSubview(currentCardView)
        currentCardView.addSubview(cardFrontSideTextView)
        currentCardView.addSubview(cardBackSideTextView)
        currentCardView.addGestureRecognizer(cardViewTapGesture)
        
        containerView.addSubview(buttonSeparatorView)
        containerView.addSubview(flipCardButton)
        containerView.addSubview(wrongAnswerButton)
        containerView.addSubview(correctAnswerButton)
        
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            currentProgressBarView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            currentProgressBarView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            currentProgressBarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            currentProgressBarView.heightAnchor.constraint(equalToConstant: 10),
            
            
            currentCardView.leftAnchor.constraint(equalTo: currentProgressBarView.leftAnchor),
            currentCardView.rightAnchor.constraint(equalTo: currentProgressBarView.rightAnchor),
            currentCardView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 45),
            currentCardView.heightAnchor.constraint(equalToConstant: 450),
            
            cardFrontSideTextView.leftAnchor.constraint(equalTo: currentCardView.leftAnchor, constant: 30),
            cardFrontSideTextView.rightAnchor.constraint(equalTo: currentCardView.rightAnchor, constant: -30),
            cardFrontSideTextView.topAnchor.constraint(equalTo: currentCardView.topAnchor, constant: 30),
            /*
             Bottom anchor lessThanOrEqualTo = the label will dynamically autosize
             vertically until it hits (30 pts above) the currentCardView's
             bottom anchor - this allows us to somewhat force top+left alignment
             */
            cardFrontSideTextView.bottomAnchor.constraint(lessThanOrEqualTo: currentCardView.bottomAnchor, constant: -30),
            
            cardBackSideTextView.leftAnchor.constraint(equalTo: currentCardView.leftAnchor, constant: 30),
            cardBackSideTextView.rightAnchor.constraint(equalTo: currentCardView.rightAnchor, constant: -30),
            cardBackSideTextView.topAnchor.constraint(equalTo: currentCardView.topAnchor, constant: 30),
            cardBackSideTextView.bottomAnchor.constraint(lessThanOrEqualTo: currentCardView.bottomAnchor, constant: -30),
            
            
            buttonSeparatorView.heightAnchor.constraint(equalToConstant: 70),
            buttonSeparatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100),
            buttonSeparatorView.widthAnchor.constraint(equalToConstant: 35),
            buttonSeparatorView.centerXAnchor.constraint(equalTo: currentCardView.centerXAnchor),
            
            flipCardButton.bottomAnchor.constraint(equalTo: buttonSeparatorView.topAnchor, constant: -10),
            flipCardButton.heightAnchor.constraint(equalToConstant: 50),
            flipCardButton.leftAnchor.constraint(equalTo: currentCardView.leftAnchor),
            flipCardButton.rightAnchor.constraint(equalTo: currentCardView.rightAnchor),
            
            correctAnswerButton.rightAnchor.constraint(equalTo: currentCardView.rightAnchor),
            correctAnswerButton.leftAnchor.constraint(equalTo: buttonSeparatorView.rightAnchor),
            correctAnswerButton.topAnchor.constraint(equalTo: buttonSeparatorView.topAnchor),
            correctAnswerButton.bottomAnchor.constraint(equalTo: buttonSeparatorView.bottomAnchor),
            
            wrongAnswerButton.leftAnchor.constraint(equalTo: currentCardView.leftAnchor),
            wrongAnswerButton.rightAnchor.constraint(equalTo: buttonSeparatorView.leftAnchor),
            wrongAnswerButton.topAnchor.constraint(equalTo: buttonSeparatorView.topAnchor),
            wrongAnswerButton.bottomAnchor.constraint(equalTo: buttonSeparatorView.bottomAnchor)
            
        ])
    }
    
    
    // MARK: Button/gesture methods

    @objc func didTapFlipCardButton() {
        
        // MARK: Flip cards
        
        if wrongAnswerButton.backgroundColor == UIColor.lightGray.withAlphaComponent(0.25) {
            wrongAnswerButton.backgroundColor = UIColor(hex: "CE3A3A")
            correctAnswerButton.backgroundColor = UIColor(hex: "3ACE3A")
        }
        
        if cardFrontSideTextView.isHidden {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                
                self.cardFrontSideTextView.alpha = 1
                self.cardBackSideTextView.alpha = 0
            }) { [weak self] (bool) in
                guard let self = self else { return }
                
                self.cardFrontSideTextView.isHidden = false
                self.cardBackSideTextView.isHidden = true
            }
            return
        }
        
        if cardBackSideTextView.isHidden {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                
                self.cardBackSideTextView.alpha = 1
                self.cardFrontSideTextView.alpha = 0
            }) { [weak self] (bool) in
                guard let self = self else { return }
                
                self.cardBackSideTextView.isHidden = false
                self.cardFrontSideTextView.isHidden = true
            }
            return
        }
    }
    
    
    // TODO: MAKE IT TINDER CARDS
    // MARK: Tap correct answer
    @objc func didTapCorrectAnswerButton() {
        incrementProgressBar()
        
        if cardFrontSideTextView.isHidden {
            didTapFlipCardButton()
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.currentCardView.backgroundColor = UIColor.green.withAlphaComponent(0.25)
            self.currentCardView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            
            self.wrongAnswerButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            self.correctAnswerButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        }
        
        delegate?.didTapCorrectAnswerButton()
    }
    
    // MARK: Tap wrong answer
    @objc func didTapWrongAnswerButton() {
        incrementProgressBar()
        
        if cardFrontSideTextView.isHidden {
            didTapFlipCardButton()
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.currentCardView.backgroundColor = UIColor.red.withAlphaComponent(0.25)
            self.currentCardView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            
            self.wrongAnswerButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            self.correctAnswerButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        }
        
        delegate?.didTapWrongAnswerButton()
    }
    
    // MARK: Helper methods
    func incrementProgressBar() {
        guard !progress.isFinished else { return }
        
        progress.completedUnitCount += 1
        let progressFloat = Float(progress.fractionCompleted)
        currentProgressBarView.setProgress(progressFloat, animated: true)
        
        if progress.isFinished {
            delegate?.didFinishProgressBar()
        }
    }
    
    func configureCardView(cardModel: ReviewCardModel) {
        cardFrontSideTextView.text = cardModel.frontSideText
        cardBackSideTextView.text = cardModel.backSideText
        
        cardBackSideTextView.isHidden = true
    }
    
    
}
