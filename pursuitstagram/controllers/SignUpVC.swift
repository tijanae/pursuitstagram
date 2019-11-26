//
//  SignUpVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 11/25/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
    
    // MARK: -- ObjectProperties
    
    lazy var username: UITextField = {
        let usersName = UITextField()
        return usersName
    }()
    
    lazy var emailTextField: UITextField = {
        let text = UITextField()
        return text
    }()
    
    lazy var passwordTextField: UITextField = {
        let passWord = UITextField()
        return passWord
    }()
    
    lazy var cancelButton: UIButton = {
        let login = UIButton()
        return login
    }()
    
    lazy var signInError: UILabel = {
        let errorLabel = UILabel()
        return errorLabel
    }()
    
    lazy var signUpButton: UIButton = {
        let signUp = UIButton()
        signUp.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
        return signUp
    }()
    
    
    @objc func signUpPressed(_ sender: UIButton){
           let error = validateFields()
           
           if error != nil {
               self.showError(error!)
           } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // creating the user on the database
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    self.showError("NO!")
                } else{
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["uid": result!.user.uid])
                    //
                }
            }
               
           }
       }

    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Passwords must be 6 characters long and include a number!"
        }

            return nil
        }
    
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9]).{5,}")
        return passwordTest.evaluate(with: password)
    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
        }
        
        
        // MARK: -- Private Constraints, SubViews, Delegates
        
    //    private func
        
        private func showError(_ message: String) {
            signInError.text = message
            signInError.alpha = 1
            signInError.numberOfLines = 0
        }
    
    private func transitionToLogin() {
        // transition to login automatically if user is created effectively
        print("ayeee a user was created")
    }
    

}
