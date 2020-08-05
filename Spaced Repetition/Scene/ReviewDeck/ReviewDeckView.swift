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
        txtView.isSelectable = false
        txtView.font = UIFont.boldSystemFont(ofSize: 26)
        
        return txtView
    }()
    
    let cardBackSideTextView: UITextView = {
        let txtView = UITextView(frame: .zero)
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.textAlignment = .left
        txtView.backgroundColor = .clear
        txtView.isSelectable = false
        txtView.font = UIFont.boldSystemFont(ofSize: 26)
        
        return txtView
    }()
    
    // MARK: Card model
    struct ReviewCardModel {
        let frontSideText: String
        let backSideText: String
    }
    
    
    // MARK: Flip card tap gesture
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
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .white
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 7
        
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapWrongAnswerButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = UIColor(hex: "CE3A3A")
        
        return button
    }()
    
    // MARK: Correct answer button
    lazy var correctAnswerButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .white
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 7
        
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapCorrectAnswerButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: config)
        button.setImage(checkmarkImage, for: .normal)
        button.tintColor = UIColor(hex: "3ACE3A")
        
        return button
    }()
    
    
    // MARK: Pan card gesture
    lazy var panCardGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panCard(sender:)))
        
        return pan
    }()
    
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupSubviews()
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
        currentCardView.addGestureRecognizer(panCardGesture)
        
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
            
            flipCardButton.topAnchor.constraint(equalTo: currentCardView.bottomAnchor, constant: 20),
            flipCardButton.heightAnchor.constraint(equalToConstant: 50),
            flipCardButton.leftAnchor.constraint(equalTo: currentCardView.leftAnchor),
            flipCardButton.rightAnchor.constraint(equalTo: currentCardView.rightAnchor),
            
            correctAnswerButton.centerXAnchor.constraint(equalTo: currentCardView.centerXAnchor, constant: 80),
            correctAnswerButton.centerYAnchor.constraint(equalTo: flipCardButton.bottomAnchor, constant: 60),
            correctAnswerButton.heightAnchor.constraint(equalToConstant: 70),
            correctAnswerButton.widthAnchor.constraint(equalToConstant: 70),
            
            wrongAnswerButton.centerXAnchor.constraint(equalTo: currentCardView.centerXAnchor, constant: -80),
            wrongAnswerButton.centerYAnchor.constraint(equalTo: correctAnswerButton.centerYAnchor),
            wrongAnswerButton.heightAnchor.constraint(equalToConstant: 70),
            wrongAnswerButton.widthAnchor.constraint(equalToConstant: 70)
            
        ])
    }
    
    
    // MARK: Button/gesture methods

    @objc func didTapFlipCardButton() {
        
        // MARK: Flip cards
        
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
    
    // MARK: Pan card
    @objc func panCard(sender: UIPanGestureRecognizer) {
        guard let card = sender.view else { return }
        let point = sender.translation(in: containerView)
        
        /*
         The true center.y of the view is 248 points above the container view center
         This is due to the topAnchor of the containerView being anchored to the
         top anchor of the layoutMarginsGuide for a large display title
         
         We then subtract this number from the y value when updating the new card center
         to get the true center it should be at
         */
        let adjustedYPointFromMarginsGuide: CGFloat = 248.0
        
        // continuously update card center point to new touch point
        card.center = CGPoint(x: containerView.center.x + point.x, y: containerView.center.y + point.y - adjustedYPointFromMarginsGuide)
        
        if sender.state == .ended {
            
            if card.center.x < 50 {
                // move card off to the left and down
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                
                didTapWrongAnswerButton()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.resetCardPositionAndAlpha(cardView: card)
                }
                
                return
                
            } else if card.center.x > (containerView.frame.width - 50) {
                // move card off to the right and down
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                
                didTapCorrectAnswerButton()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.resetCardPositionAndAlpha(cardView: card)
                }
                
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                // this point is the original card center
                card.center = CGPoint(x: 207.0, y: 270.0)
            }
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
    
    
    func resetCardPositionAndAlpha(cardView: UIView) {
        cardView.center = CGPoint(x: 207.0, y: 270.0)
        
        UIView.animate(withDuration: 0.2) {
            cardView.alpha = 1
        }
        
    }
    
    func configureCardView(cardModel: ReviewCardModel) {
        cardFrontSideTextView.text = cardModel.frontSideText
        cardBackSideTextView.text = cardModel.backSideText
        
        cardBackSideTextView.isHidden = true
    }
    
    
}
