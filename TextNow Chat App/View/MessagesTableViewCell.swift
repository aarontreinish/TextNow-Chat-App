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
    
    var message: Message? {
        didSet {
           
            setupNameAndProfileImage()
            
            chatPreviewLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }


        }
    }
    
    func setupNameAndProfileImage() {
    
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.nameLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }

    }
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatPreviewLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = 24
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
