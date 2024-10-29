//
//  UIViewContolller+KeyboardObserve.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 29/10/2024.
//

import UIKit

class KeyboardRespondingViewController: UIViewController {
    
    @IBOutlet weak var nextButtonBottomSpaceConstraint: NSLayoutConstraint!
    
    // hello darkness my old friend.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedLayout(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedLayout(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardChangedLayout(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.4
        
        let keyboardSize = keyboardFrame?.size
        UIView.animate(withDuration: animationDuration) {
            if notification.name == UIResponder.keyboardWillHideNotification {
                self.nextButtonBottomSpaceConstraint.constant = 52
            } else if let keyboardHeight = keyboardSize?.height  {
                self.nextButtonBottomSpaceConstraint.constant = keyboardHeight
            }
        }
    }
}
