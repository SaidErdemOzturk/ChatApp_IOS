//
//  UyelerClass.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 26.03.2022.
//

import Foundation
import MessageKit
struct Sender: SenderType{
    var senderId: String
    var displayName: String
    var photoURL: URL?
    var email: String
    var secondName: String

    
    init(displayName : String, email : String, senderId : String, photoURL: URL,secondName: String) {
        self.displayName = displayName
        self.email = email
        self.senderId = senderId
        self.photoURL = photoURL
        self.secondName = secondName
        
    }
    
}
