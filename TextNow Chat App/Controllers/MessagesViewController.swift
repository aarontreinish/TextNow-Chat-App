//
//  MessagesViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/14/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up nav bar to be able to logout
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkIfUserIsLoggedIn()
        
        observeUserMessages()
        
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in

            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)

            messageReference.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)

                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message

                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in

                            return message1.timestamp!.intValue > message2.timestamp!.intValue
                        })
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)

        }, withCancel: nil)

    }
    
    
    //checks if user is already logged in
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    //gets the user and displays it in nav bar
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        
        /*BUG: Obsolete messages displayed.
        Error occursWhen logging out and signing back in an error occurs at tableView.reloadData()
         */
//        messages.removeAll()
//        messagesDictionary.removeAll()
//        tableView.reloadData()
//        observeUserMessages()
        
        
        self.navigationItem.title = user.name
    }
    
    //Logs out user when button is pressed
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOut", sender: self)
            messages.removeAll()
            messagesDictionary.removeAll()
        } catch let logoutError {
            print(logoutError)
        }
        let signInViewController = SignInViewController()
        signInViewController.messagesViewController = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessagesTableViewCell else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
    
    func showChatControllerForUser(user: User) {
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.user = user
        navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    
    //segues to new new message view controller
    @IBAction func newMessageButtonAction(_ sender: Any) {
        let newMessageViewController = NewMessageViewController()
        newMessageViewController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageViewController)
        present(navController, animated: true, completion: nil)
    }
    
    
}
