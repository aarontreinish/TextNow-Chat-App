//
//  LoginController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/24/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var messagesViewController: MessagesViewController?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets up nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 83/255, green: 27/255, blue: 147/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        createButton.tintColor = UIColor.white
        
        
        //sets up tapping to select profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    //handles picking the profile image
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    //sets the picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //creating a user to the firebase database
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        
        ProgressHUD.show("Waiting...")
        Auth.auth().createUser(withEmail: email, password: password, completion: { ( user, error) in
            if error != nil {
                print(error)
                ProgressHUD.showError()
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://textnow-chat-app.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": username, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: {
                (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                self.messagesViewController?.fetchUserAndSetUpNavBarTitle()
                //successfully logged in
                ProgressHUD.showSuccess("Success")
                self.performSegue(withIdentifier: "signUp", sender: self)
                
            })
            
        })
        
    }
    
}
