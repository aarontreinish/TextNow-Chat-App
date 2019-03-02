//
//  CreateViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/16/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
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
    
    //  sets the picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let selectedImage = info[.originalImage] as? UIImage {
            
            profileImageView.image = selectedImage
            
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
            dismiss(animated: true, completion: nil)
    }
    
    //creating a user to the firebase database
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text else {
            print("Form is not valid")
            return
        }
        ProgressHUD.show("Waiting...")
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = res?.uid else {
                return
            }
            
            //successfully authenticated user
            ProgressHUD.showSuccess("Success")
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        guard let url = url else { return }
                        let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    })
                    
                })
            }
        })
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            self.messagesViewController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
