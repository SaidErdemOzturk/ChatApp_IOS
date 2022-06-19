//
//  GroupChatViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 14.05.2022.
//

import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import SDWebImage
import InputBarAccessoryView




class GroupChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate,MessagesDisplayDelegate, InputBarAccessoryViewDelegate{
    var grup = Gruplar(ad: "", uid: "", uyeler: [])
    var user = Sender(displayName: "",email: "",  senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    var grupMesajlar : Array<Dictionary<String, String>>=[]
    var friendSender = Sender(displayName: "", email: "", senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func getData(){

        
        
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).getDocument { documentSnapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                self.user.displayName = documentSnapshot!.get("displayName") as! String
                self.user.secondName = documentSnapshot!.get("secondName") as! String
                self.user.email = documentSnapshot!.get("email") as! String
                self.user.senderId = documentSnapshot!.get("senderId") as! String
                self.user.photoURL = URL(string: documentSnapshot!.get("photoURL") as! String)
                
            }
        }
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").document(grup.uid).collection("Mesajlar").order(by: "messageId").addSnapshotListener { querySnapshot, error in
            if error != nil{
                
            }else{
                if querySnapshot?.documents.isEmpty == true {
                    
                }else{
                    self.messages.removeAll()
                    for document in querySnapshot!.documents {
                        
                        Firestore.firestore().collection("Kullanicilar").document(document.get("senderId") as! String).addSnapshotListener { documentSnapshot, error in
                            if error != nil{
                                
                            }else{
                                if documentSnapshot!.get("senderId") as! String == self.user.senderId {
                                    self.messages.append(Message(sender: self.user, sender1: self.user, messageId: String(document.get("messageId") as! Int), sentDate: Date().addingTimeInterval(-1), kind: .text(document.get("kind") as! String)))
                                }else{
                                    self.friendSender = Sender(displayName: documentSnapshot!.get("displayName") as! String, email: documentSnapshot!.get("email") as! String, senderId: documentSnapshot!.get("senderId") as! String, photoURL: URL(string: documentSnapshot!.get("photoURL") as! String)!, secondName: documentSnapshot!.get("secondName") as! String)
                                    
                                    
                                    self.messages.append(Message(sender: self.friendSender  , sender1: self.friendSender , messageId: String(document.get("messageId") as! Int), sentDate: Date().addingTimeInterval(-1), kind: .text(document.get("kind") as! String)))
                                }
                            }
                            self.messagesCollectionView.reloadData()
                        }
                    }
                }
            }
        }

      
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            
            return NSAttributedString(string: message.sender.displayName,attributes: [.font: UIFont.systemFont(ofSize: 16)])
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 25
    }
    
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.sd_setImage(with: messages[indexPath.section].sender1.photoURL, completed: nil)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        var lastMessageId = 0
        if messageInputBar.inputTextView.text != "" {
            if messages.count != 0 {
                lastMessageId = (Int(messages[messages.count-1].messageId)!)+1
            }
            
            self.messages.append(Message(sender: self.user, sender1: self.user, messageId: String(lastMessageId), sentDate: Date()  , kind:.text(messageInputBar.inputTextView.text) ))
            for item in grup.uyeler {
                Firestore.firestore().collection("Kullanicilar").document(item).collection("Gruplar").document(grup.uid).collection("Mesajlar").addDocument(data: ["senderId" : messages[messages.count-1].sender.senderId,"messageId" : lastMessageId,"sentDate" : Date() ,"kind" : messageInputBar.inputTextView.text!])
            }
            messageInputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
        }
    }
    
    func currentSender() -> SenderType {
        return user
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
