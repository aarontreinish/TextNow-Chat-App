//
//  SignInViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/13/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD


class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var messagesViewController = MessagesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //sets up nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 83/255, green: 27/255, blue: 147/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        nextButton.tintColor = UIColor.white
        
    }
    
    
    //logs user back in to app with Firebase
    @IBAction func logInButtonAction(_ sender: Any) {
        ProgressHUD.show("Signing In...", interaction: false)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                print(error!)
                ProgressHUD.showError("Error, try again")
                return
            }
            
            self.messagesViewController.fetchUserAndSetupNavBarTitle()
            
            //successfully logged in
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "logIn", sender: self)
            
        })
    }
    
}
