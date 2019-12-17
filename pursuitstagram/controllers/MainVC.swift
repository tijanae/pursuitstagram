//
//  MainVC.swift
//  pursuitstagram
//
//  Created by Tia Lendor on 11/25/19.
//  Copyright © 2019 Tia Lendor. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainVC: UIViewController {
    
    var user = AppUser(from: FirebaseAuthService.manager.currentUser!)
    
    var userPosts = [Post] () {
        didSet {
            postCollectionView.reloadData()
        }
    }
    
    lazy var logout: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(logoutSelected))
        return button
    }()
    
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .lightGray
        cv.register(mainCVC.self, forCellWithReuseIdentifier: "mainCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    
    
    
    @objc func logoutSelected() {
        FirebaseAuthService.manager.signOut()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else {
                        return
                }
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                    window.rootViewController = loginVC()
                }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "hello \(hello())!"
        self.navigationItem.rightBarButtonItem = logout
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        getPosts()
        constrainBooksCollectionView()
        
        
        
    }
    
    private func hello() -> String {
        var usersName = user.userName
        var helloThere = "my new friend"
        if usersName == nil {
            return helloThere
        } else {
            return usersName!
        }
    }
    
    private func getPosts(){
          FirestoreService.manager.getAllPosts { (result) in
              DispatchQueue.main.async {
                  switch result{
                  case .failure(let error):
                      print(error)
                  case .success(let data):
                      self.userPosts = data
//                    data.filter
//                        { (post) -> Bool in
//                          return post.creatorID != self.user.uid
//                      }
                      print(data.count)
                  }
              }
          }
        
    }
    
    private func constrainBooksCollectionView(){
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            postCollectionView.heightAnchor.constraint(equalToConstant: 300),
            postCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("i got \(userPosts.count)")
        
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? mainCVC else {return UICollectionViewCell()}
         let data = userPosts[indexPath.row]
        cell.configureCell(post: data)
     
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
