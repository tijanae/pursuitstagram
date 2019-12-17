//
//  SettingsVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 12/16/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var user = AppUser(from: FirebaseAuthService.manager.currentUser!)
    
    lazy var userName: UILabel = {
        let name = UILabel()
        name.text = "Hello Default"
        return name
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultpicture")
        return imageView
    }()
    
    lazy var editProfileImage: UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitleColor(.white, for: .normal)
        signUp.setTitle("edit", for: .normal)
        signUp.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return signUp
    }()
    
    lazy var confirmProfile: UIButton = {
        let profile = UIButton()
        profile.backgroundColor = .blue
        profile.setTitleColor(.white, for: .normal)
        profile.setTitle("update", for: .normal)
        profile.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        return profile
    }()
    
    lazy var userNameTextField: UITextField = {
        let text = UITextField()
        text.text = "new username"
        text.borderStyle = .line
        text.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return text
    }()
    
    @objc func validateFields() {
        guard userNameTextField.hasText else {
         confirmProfile.backgroundColor = .blue
            confirmProfile.isEnabled = false
            return
        }
        confirmProfile.isEnabled = true
     confirmProfile.backgroundColor = .darkGray
    }
    
    @objc func editProfile() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    
    @objc func updateUser() {
        
        guard let newUserName = userNameTextField.text else {
            showAlert(title: "No username entered", message: "Please enter a new username.")
            return
        }
        
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 1.0) else {
            showAlert(title: "No image selected", message: "Please select a profile image.")
            return
        }
        
        
        FirebaseStorage.profileManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let url):
                FirebaseAuthService.manager.updateUserFields(userName: newUserName, photoURL: url) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(()):
                        FirestoreService.manager.updateCurrentUser(userName: newUserName, photoURL: url) { [weak self] (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(()):
                                self!.showAlert(title: "Success!", message: "Profile successfully updated.")
                            }
                        }
                    }
                }
            }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        addSubViews()
        constraints()
        

        // Do any additional setup after loading the view.
    }
    
    private func setUp() {
        if user.userName == nil {
            userName.text = user.email
        } else {
            userName.text = user.userName
        }
        
        if let photoUrl = user.photoURL {
        FirebaseStorage.profileManager.getImages(profileUrl: photoUrl) { (result) in
            switch result{
            case .failure(let error):
                self.profileImageView.image = UIImage(named: "noImage")
            case .success(let data):
                self.profileImageView.image = UIImage(data: data)
            }
        }
        } else {
            self.profileImageView.image = UIImage(named: "noImage")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    private func addSubViews() {
        view.addSubview(profileImageView)
        view.addSubview(userName)
        view.addSubview(editProfileImage)
        view.addSubview(confirmProfile)
        view.addSubview(userNameTextField)
        }
    
    private func constraints() {
        defaultImageConstraint()
        userNameConstraint()
        editImageConstraint()
        confirmConstraint()
        userNameTextConstraint()
    }
    
    private func defaultImageConstraint() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        [profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
         profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
         profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
         profileImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  400)].forEach{$0.isActive = true}
    }
    
    private func userNameConstraint() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        [userName.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
         userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
         userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
         userName.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  175)].forEach{$0.isActive = true}
    }
    
    private func editImageConstraint() {
        editProfileImage.translatesAutoresizingMaskIntoConstraints = false
        [editProfileImage.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25),
            editProfileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            editProfileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
        
    }
    
    private func confirmConstraint() {
        confirmProfile.translatesAutoresizingMaskIntoConstraints = false
        [confirmProfile.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25),
            confirmProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            confirmProfile.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250)].forEach{$0.isActive = true}
        
    }

    
    private func userNameTextConstraint() {
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        [userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
         userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
    }
   

}

extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        self.profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
