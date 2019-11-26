//
//  loginVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 11/25/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginVC: UIViewController {
    
    

    // MARK: -- ObjectProperties
    lazy var emailTextField: UITextField = {
        let text = UITextField()
        return text
    }()
    
    lazy var passwordTextField: UITextField = {
        let passWord = UITextField()
        return passWord
    }()
    
    lazy var signInError: UILabel = {
        let errorLabel = UILabel()
        return errorLabel
    }()
    // make error label invisible when view loads using .alpha = 0
    
    lazy var loginButton: UIButton = {
        let login = UIButton()
        login.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        return login
    }()
    
    lazy var signUpButton: UIButton = {
        let signUp = UIButton()
        return signUp
    }()
    
    @objc func loginPressed(_ sender: UIButton){
        let error = validateFields()
        
        if error != nil {
            self.showError(error!)
        } else {
            
        }
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
    
    
    // MARK: -- Private Constraints, SubViews, Delegates
    
//    private func
    
    private func showError(_ message: String) {
        signInError.text = message
        signInError.alpha = 1
        signInError.numberOfLines = 0
    }
    
    
    

    

}
