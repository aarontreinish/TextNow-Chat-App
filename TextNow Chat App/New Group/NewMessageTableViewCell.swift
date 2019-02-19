//
//  NewMessageTableViewCell.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/16/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        //sets up profile image in cell
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
