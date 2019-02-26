//
//  NewMessageViewController.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/16/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets up cancel button in navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNewMessage))
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        fetchUser()

    }
 
    @objc func cancelNewMessage() {
        performSegue(withIdentifier: "cancelNewMessage", sender: self)
    }


    //fetches the user to display on tableview
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: {
            (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()

                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.users)
            }
        })
    }
    
    //returns the amount of cells for the amount of users
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //displays user and there profile image
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell") as? NewMessageTableViewCell else { return UITableViewCell() }

        let user = users[indexPath.row]
        cell.usersLabel.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMessage", sender: nil)
    }
    
}
