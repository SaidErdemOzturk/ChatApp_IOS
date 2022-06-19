//
//  ChatViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 29.04.2022.
//

import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import InputBarAccessoryView
import SDWebImage





struct Message : MessageType {
    var sender: SenderType
    
    var sender1: Sender
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
}





class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    var mesajlar : Array<Dictionary<String, String>>=[]
    var friend = Sender(displayName: "",email: "",  senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    var user = Sender(displayName: "",email: "",  senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    
    var messages: [Message] = []
    override func viewWillAppear(_ animated: Bool) {
        user.displayName=Auth.auth().currentUser!.displayName!
        user.email = Auth.auth().currentUser!.email!
        user.senderId = Auth.auth().currentUser!.uid
        user.photoURL = Auth.auth().currentUser!.photoURL

        getData()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    
    
    func currentSender() -> SenderType {
        return user
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.sd_setImage(with: messages[indexPath.section].sender1.photoURL, completed: nil)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func getData(){
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Arkadaslar").document(friend.senderId).collection("Mesajlar").order(by: "messageId").addSnapshotListener { querySnapshot, error in
            if error != nil{
                
            }else{
                if querySnapshot?.documents.isEmpty == true {
                    print("Hiç veri yok")
                }else{
                    self.messages.removeAll()
                    for document in querySnapshot!.documents {
                     
                        if document.get("senderId") as! String == self.user.senderId {
                            self.messages.append(Message(sender: self.user, sender1: self.user, messageId: String(document.get("messageId") as! Int), sentDate: Date() , kind:.text(document.get("kind") as! String) ))
                        }
                        else{
                            self.messages.append(Message(sender: self.friend, sender1: self.friend, messageId: String(document.get("messageId") as! Int), sentDate: Date(), kind: .text(document.get("kind") as! String)))
                        }
                    }
                }
            }
            self.messagesCollectionView.reloadData()
        }
    }
    

    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        var lastMessageId = 0
        

       
        if messageInputBar.inputTextView.text != "" {
            if messages.count != 0 {
                lastMessageId = (Int(messages[messages.count-1].messageId)!)+1
            }
            self.messages.append(Message(sender: self.user, sender1: self.user, messageId: String(lastMessageId), sentDate: Date()  , kind: .text(messageInputBar.inputTextView.text)))

            Firestore.firestore().collection("Kullanicilar").document(user.senderId).collection("Arkadaslar").document(friend.senderId).collection("Mesajlar").addDocument(data: ["senderId" : messages[messages.count-1].sender.senderId,"messageId" : lastMessageId,"sentDate" : Date(),"kind" : messageInputBar.inputTextView.text!])
            
            Firestore.firestore().collection("Kullanicilar").document(friend.senderId).collection("Arkadaslar").document(user.senderId).collection("Mesajlar").addDocument(data: ["senderId" : messages[messages.count-1].sender.senderId,"messageId" : lastMessageId,"sentDate" : Date(),"kind" : messageInputBar.inputTextView.text!])

            messageInputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
        }
        
    }
    
    
    
    /* grup için isim ayarı
     
     
     
     

    


 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
