//
//  MessageDetail.swift
//  TextNow Chat App
//
//  Created by Aaron Treinish on 2/25/19.
//  Copyright © 2019 Aaron Treinish. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MessageDetail {
    private var _recipient: String!
    private var _messageKey: String!
    private var _messageRef: DatabaseReference!
    
    var currentUser = Auth.auth().currentUser
    
    var recipient: String {
        return _recipient
    }
    
    var messageKey: String {
        return _messageKey
    }
    
    var messageRef: DatabaseReference {
        return _messageRef
    }
    
    init(recipient: String) {
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            _recipient = recipient
        }
        
        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
    }
    
    
}
