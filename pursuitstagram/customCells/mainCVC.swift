//
//  mainCVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 12/16/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit

class mainCVC: UICollectionViewCell {
    
    lazy var userImages : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultpicture")
        return imageView
    }()
    
    lazy var creator: UILabel = {
        let name = UILabel()
        name.text = "i made this"
        return name
    }()
    
    lazy var dateCreated: UILabel = {
        let name = UILabel()
        name.text = "IN DECEMBER"
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        contentView.backgroundColor = .white
    }
    
    private func addViews(){
        contentView.addSubview(userImages)
        contentView.addSubview(creator)
        contentView.addSubview(dateCreated)
        
    }
    private func addConstraints(){
        constrainImageView()
        constrainCreatorName()
        constrainDateText()
    }
    private func constrainImageView(){
        userImages.translatesAutoresizingMaskIntoConstraints = false
        [userImages.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
         userImages.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
         userImages.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.50),
         userImages.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44)
            ].forEach{$0.isActive = true}
    }
    
    private func constrainCreatorName(){
        creator.translatesAutoresizingMaskIntoConstraints = false
        creator.topAnchor.constraint(equalTo: userImages.bottomAnchor).isActive = true
        creator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(11)).isActive = true
        creator.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.10).isActive = true
        creator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11).isActive = true
    }
    private func constrainDateText(){
        dateCreated.translatesAutoresizingMaskIntoConstraints = false
        [dateCreated.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
         dateCreated.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
         dateCreated.topAnchor.constraint(equalTo: creator.bottomAnchor, constant: 0),
         dateCreated.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
            ].forEach{$0.isActive = true}
    }
    
    func configureCell(post: Post) {
        FirebaseStorage.postManager.getImages(profileUrl: post.imageUrl!) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let imageData):
                self.userImages.image = UIImage(data: imageData)
            }
        }
        FirestoreService.manager.getUserFromPost(creatorID: post.creatorID) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let user):
                    if let userName = user.userName {
                        self.creator.text = userName
                    } else if let email = user.email {
                        self.creator.text = email
                    } else {
                        self.creator.text = "New User"
                    }
                }
            }
        }
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
