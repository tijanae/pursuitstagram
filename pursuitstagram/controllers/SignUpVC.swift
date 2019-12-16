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
        text.text = "email"
        text.borderStyle = .line
        text.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return text
    }()
    
    lazy var passwordTextField: UITextField = {
        let passWord = UITextField()
        passWord.text = "password"
        passWord.borderStyle = .line
        passWord.addTarget(self, action: #selector(validateFields), for: .editingChanged)
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
        signUp.backgroundColor = .blue
        signUp.setTitle("sign up", for: .normal)
        signUp.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        return signUp
    }()
    
    


    @objc func validateFields() {
          guard emailTextField.hasText, passwordTextField.hasText else {
            signUpButton.backgroundColor = .darkGray
              signUpButton.isEnabled = false
              return
          }
          signUpButton.isEnabled = true
    signUpButton.backgroundColor = .darkGray
      }
    
    @objc func trySignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                    self?.handleCreatedUserInFirestore(result: newResult)
                    self?.showAlert(with: "Congrats!", and: "You've Joined this App")
                }
            case .failure(let error):
                self?.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<(), Error>) {
        switch result {
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                           else {
                               return
                       }

                       UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                            let signupVC = MainVC()
                            signupVC.modalPresentationStyle = .formSheet
                            self.present(signupVC, animated: true, completion: nil)

                                   }, completion: nil)
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
        }
    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            constraints()
            addSubViews()
        }
        
        
        // MARK: -- Private Constraints, SubViews, Delegates
    
    private func setDelegates() {
        
    }
    
    private func addSubViews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
    }
    
    private func constraints() {
        emailTextConstraint()
        passwordTextConstraint()
        signInConstraint()
        
    }
    
//    private func usernameConstraint() {
//
//    }
    
    private func emailTextConstraint() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        [emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
          emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
          emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
        
    }
    
    private func passwordTextConstraint() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
    }
    
    
    private func signInConstraint() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        [signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
             signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
             signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)].forEach{$0.isActive = true}
    }
//    private func cancelConstraint() {
//
//    }
    

    
    
        
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
