//
//  UploadVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 12/16/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit

class UploadVC: UIViewController {
    
    var user = AppUser(from: FirebaseAuthService.manager.currentUser!)
    
    lazy var imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultpicture")
        return image
    }()
    
    lazy var addImage: UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitleColor(.white, for: .normal)
        signUp.setTitle("add", for: .normal)
        signUp.addTarget(self, action: #selector(addImages), for: .touchUpInside)
        return signUp
    }()
    
    lazy var uploadImage: UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitleColor(.white, for: .normal)
        signUp.setTitle("upload", for: .normal)
        signUp.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return signUp
    }()
    
    @objc func addImages() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = .photoLibrary
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    
    @objc func upload() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1.0) else {
        showAlert(title: "No Image Selected", message: "Please select an image to upload.")
        return
    }
        FirebaseStorage.postManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result {
            case .success(let url):
                let post = Post(creatorID: self!.user.uid, dateCreated: nil, imageUrl: url.absoluteString )
                FirestoreService.manager.createPost(post: post) { (result) in
                    switch result{
                    case .success(()):
                        self?.showAlert(title: "Success!", message: "Photo successfully uploaded.")
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                self?.showAlert(title: "Error", message: "An error occurred while uploading photo.")
                print(error)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpUpload()
        addSubViews()
        constraints()

        // Do any additional setup after loading the view.
    }
    
    
//    imageView.image = UIImage(named: "defaultpicture")
    
    private func setUpUpload() {
        imageView.image = UIImage(named: "defaultpicture")
    }
    
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(uploadImage)
        view.addSubview(addImage)
        
        }
    
    private func constraints() {
        imageConstraint()
        uploadImageConstraint()
        addImageConstraint()
        
    }
    
    private func imageConstraint() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
         imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
         imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
         imageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant:  400)].forEach{$0.isActive = true}
    }

    private func uploadImageConstraint() {
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        [uploadImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            uploadImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            uploadImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)].forEach{$0.isActive = true}
    }
    
    private func addImageConstraint() {
        addImage.translatesAutoresizingMaskIntoConstraints = false
        [addImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            addImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250)].forEach{$0.isActive = true}
        
    }
    
    

}

extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let addedimage = info[.originalImage] as? UIImage else {
            return
        }
        
        self.imageView.image = addedimage
        dismiss(animated: true, completion: nil)
    }
}
