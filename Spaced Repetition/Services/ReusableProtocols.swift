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
        
        public init(title: String?, message: String?, textFields: [TextField], actions: [Action]) {
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
    
    func presentAlert(viewModel: AlertDisplayable.ViewModel, alertStyle: UIAlertController.Style)
    
}


extension AlertDisplayablePresenter {
    
    // default implementation of any AlertDisplayablePresenter - popViewController is false
    // until we specify otherwise (in case of deleting deck from the deck detail screen)
    public func presentAlert(viewModel: AlertDisplayable.ViewModel, alertStyle: UIAlertController.Style) {
        alertDisplayableViewController?.displayAlert(viewModel: viewModel, alertStyle: alertStyle)
    }
    
}


// MARK: AlertDisplayableVC
public protocol AlertDisplayableViewController {
    
    func displayAlert(viewModel: AlertDisplayable.ViewModel, alertStyle: UIAlertController.Style)
    
}

extension AlertDisplayableViewController where Self: UIViewController {
    
    public func displayAlert(viewModel: AlertDisplayable.ViewModel, alertStyle: UIAlertController.Style) {
        let vc = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: alertStyle)
        
        if alertStyle == .alert {
            viewModel.textFields.forEach { (alertTextField) in
                vc.addTextField { (textField) in
                    textField.placeholder = alertTextField.placeholder
                }
            }
        }
        
        viewModel.actions.forEach { action in
            
            vc.addAction(UIAlertAction(title: action.title, style: action.style, handler: { [weak self] actionIgnore in
                
                guard let handler = action.handler else { return }
                /*
                 we call the action's handler here if it has one
                 
                 we don't really need the alert action parameter but it requires it
                 so we pass one in anyway - the important one is the vc/alertcontroller
                 since we need to access the alert controller's textfields property
                 
                 then, we can access the alert controller's textfields property
                 wherever we declared the handler (i.e. the interactor in this case)
                 */
                
                handler(actionIgnore, vc)
                
            }))
        }
        
        present(vc, animated: true, completion: nil)
    }
}
