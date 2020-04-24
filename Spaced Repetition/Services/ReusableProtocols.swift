//
//  ReusableProtocols.swift
//  Spaced Repetition
//
//  Created by Kevin Vu on 4/22/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

// MARK: - AlertDisplayable
public enum AlertDisplayable {
    public struct ViewModel {
        let title: String?
        let message: String?
        let textFields: [TextField]
        let actions: [Action]
        
        public init(title: String?, message: String, textFields: [TextField], actions: [Action]) {
            self.title = title
            self.message = message
            self.textFields = textFields
            self.actions = actions
        }
    }
    
    public struct Action {
        let title: String?
        let style: UIAlertAction.Style
        let handler: ((UIAlertAction, UIAlertController) -> Void)?
        
        public init(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction, UIAlertController) -> Void)?) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
    
    public struct TextField {
        let placeholder: String
    }
}


// MARK: - AlertDisplayablePresenter
protocol AlertDisplayablePresenter {
    var alertDisplayableViewController: AlertDisplayableViewController? { get }
    func presentAlert(viewModel: AlertDisplayable.ViewModel)
}


extension AlertDisplayablePresenter {
    // default implementation of any AlertDisplayablePresenter
    public func presentAlert(viewModel: AlertDisplayable.ViewModel) {
        alertDisplayableViewController?.displayAlert(viewModel: viewModel)
    }
}
