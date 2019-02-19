//
//  MainViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/14/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class MessagesViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up nav bar to be able to logout
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        
        checkIfUserIsLoggedIn()
        
    }
    
    //checks if user is already logged in
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetUpNavBarTitle()
        }
    }
    
    //gets the user and displays it in nav bar
    func fetchUserAndSetUpNavBarTitle() {

        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        })
    }
    
    //Logs out user when button is pressed
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOut", sender: self)
        } catch let logoutError {
            print(logoutError)
        }
        let signInViewController = SignInViewController()
        signInViewController.messagesViewController = self
    }
    
    //segues to new new message view controller
    @IBAction func newMessageButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "newMessage", sender: self)
    }
    
    
}
