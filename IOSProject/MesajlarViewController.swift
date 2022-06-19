//
//  MesajlarViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 25.04.2022.
//

import UIKit
import Firebase
import MessageKit

var user : Sender = Sender(senderId: "", displayName: "")
var user2 : Sender = Sender(senderId: "", displayName: "")
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class MesajlarViewController: MessagesViewController ,MessagesDataSource, MessagesDisplayDelegate,MessagesLayoutDelegate{
    
    
    func currentSender() -> SenderType {
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mesajlar.count
    }
    
    var mesajlar : Array<Dictionary<String, String>>=[]
    var friend = Uyeler(ad: "", soyad: "", email: "", uid: "")
    var mUser = Auth.auth().currentUser
    
    var messages = [MessageType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Sender(senderId: "self", displayName: "ben")
        user2 = Sender(senderId: "other", displayName: "sen")
        // getData()
        messagesCollectionView.messagesDataSource =  self
        
        messagesCollectionView.messagesLayoutDelegate = self
        
        messagesCollectionView.messagesDisplayDelegate = self


        
        messages.append(Message(sender: user, messageId: "1", sentDate: Date().addingTimeInterval(-5000), kind: .text("debnemnejekhejehje")))
        messages.append(Message(sender: user, messageId: "2", sentDate: Date().addingTimeInterval(-5000), kind: .text("ss")))
        messages.append(Message(sender: user2, messageId: "3", sentDate: Date().addingTimeInterval(-5000), kind: .text("bbb")))
        messages.append(Message(sender: user2, messageId: "4", sentDate: Date().addingTimeInterval(-5000), kind: .text("aa")))

        // Do any additional setup after loading the view.
    }

   
    
    @IBOutlet weak var tableView: UITableView!

   
    func getData(){

        let docRef =  Firestore.firestore().collection("Kullanicilar").document(mUser!.uid).collection("Arkadaslar").document(friend.uid).addSnapshotListener { DocumentSnapshot, error in
            if error != nil{                print(error?.localizedDescription)
            }
            else{
                self.mesajlar = DocumentSnapshot?.get("Mesajlar") as? Array<Dictionary<String, String>> ?? [["mesaj":"deneme"]]
                print(self.mesajlar.count)
            }
        }

    }
}
