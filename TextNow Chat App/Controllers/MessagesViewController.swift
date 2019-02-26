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

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageDetail = [MessageDetail]()
    var detail: MessageDetail!
    var currentUser = Auth.auth().currentUser?.uid
    var recipient: String!
    var messageId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up nav bar to be able to logout
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkIfUserIsLoggedIn()
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.messageDetail.removeAll()
                
                for data in snapshot {
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDet = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessagesTableViewCell {
            cell.configureCell(messageDetail: messageDet)
            
            return cell
        } else {
        
        return MessagesTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = messageDetail[indexPath.row].recipient
        messageId = messageDetail[indexPath.row].messageRef.key
        
        performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ChatViewController {
            destinationViewController.recipient = recipient
            destinationViewController.messageId = messageId
        }
    }
    
    //segues to new new message view controller
    @IBAction func newMessageButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "newMessage", sender: self)
    }
    
    
}
