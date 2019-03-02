//
//  InitialViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/16/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.viewDidAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //checks if user is already logged in and segues to MessagesViewController
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 83/255, green: 27/255, blue: 147/255, alpha: 1.0)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    //perform segue to CreateAccountViewController
    @IBAction func createButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccount", sender: self)
    }
    
    //perform segue to SignInViewController
    @IBAction func signInButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "signIn", sender: self)
    }

}
