//
//  TCAViewController.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 24/09/2022.
//

import UIKit


class TCAViewController: UIViewController {
    
    // MARK: - Subviews
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    // MARK: - Navigation
    
    // MARK: - Action
    @objc func keyboardWillHide(_ sender: NSNotification){
        self.resignFirstResponder()
        self.handleKeyboardWillHide(sender)
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification){
        self.handleKeyboardWillShow(sender)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // MARK: - Helper
    
    // MARK: - Show or Hide keyboard
    func setupKeyboardHiding(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //override depend on each vc
    func handleKeyboardWillHide(_ sender: NSNotification){
        
    }
    //override depend on each vc
    func handleKeyboardWillShow(_ sender: NSNotification){
    }
    
    // MARK: - Dissmiss keyboard
    func setupDismissKeyboardGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(gesture)
        gesture.cancelsTouchesInView = false
    
    }

    
}

