//
//  MessagesTableViewCell.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/16/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {
    @IBOutlet weak var recipientNameLabel: UILabel!
    
    @IBOutlet weak var chatPreviewLabel: UILabel!
    @IBOutlet weak var recipientImageView: UIImageView!
    
    var messageDetail: MessageDetail!
    
    var userPostKey: DatabaseReference!
    
    let currentUser = Auth.auth().currentUser?.uid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(messageDetail: MessageDetail) {
        self.messageDetail = messageDetail
        
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! Dictionary <String, AnyObject>
            let username = data["username"]
            let userImage = data["userImage"]
            
            self.recipientNameLabel.text = username as? String
            
            let ref = Storage.storage().reference(forURL: userImage as! String)
            
            
            
            ref.getData(maxSize: 10000, completion: {(data, error) in
                if error != nil {
                    print("Could not load image")
                } else {
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.recipientImageView.image = image
                        }
                    }
                }
            })
        })
    }
    
    
    
}
