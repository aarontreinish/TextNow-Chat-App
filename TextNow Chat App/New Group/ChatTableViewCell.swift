//
//  ChatTableViewCell.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/26/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var recievedMessageView: UIView!
    @IBOutlet weak var recievedMessageLabel: UILabel!
    @IBOutlet weak var sentMessageView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    
    var message: Message!
    var currentUser = Auth.auth().currentUser?.uid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: Message) {
        self.message = message
        
        if message.sender == currentUser {
            sentMessageView.isHidden = false
            sentMessageLabel.text = message.message
            recievedMessageView.isHidden = true
            recievedMessageLabel.text = ""
        } else {
            sentMessageView.isHidden = true
            sentMessageLabel.text = ""
            recievedMessageView.isHidden = false
            recievedMessageLabel.text = message.message
        }
    }

}
