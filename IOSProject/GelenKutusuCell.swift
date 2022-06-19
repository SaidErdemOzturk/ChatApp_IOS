//
//  GelenKutusuCell.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 26.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore


class GelenKutusuCell: UITableViewCell {
    
    var friends = Sender(displayName: "", email: "", senderId: "", photoURL: URL(string: "www.example.com")!,secondName: "")
    var user = Sender(displayName: "", email: "", senderId: "", photoURL: URL(string: "www.example.com")!,secondName: "")

    
    @IBOutlet weak var adTextLabel: UILabel!
    @IBOutlet weak var soyadTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
  
    let mFirestore = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mFirestore.collection("Kullanicilar").document(Auth.auth().currentUser!.uid).getDocument { DocumentSnapshot, error in
            if error != nil{
                
            }
            else{
                
                self.user.displayName = DocumentSnapshot!.get("displayName") as! String
                self.user.email = DocumentSnapshot!.get("email") as! String
                self.user.senderId = Auth.auth().currentUser!.uid
                self.user.photoURL = URL(string: DocumentSnapshot!.get("photoURL") as! String)!
                self.user.secondName = DocumentSnapshot!.get("secondName") as! String
            }
        }
        
        

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addFriends(_ sender: Any) {
        mFirestore.collection("Kullanicilar").document(user.senderId).collection("Arkadaslar").document(friends.senderId).setData(["senderId":friends.senderId])
        
        
        mFirestore.collection("Kullanicilar").document(friends.senderId).collection("Arkadaslar").document(user.senderId).setData(["senderId":user.senderId])
        
        mFirestore.collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("GelenKutusu").document(friends.senderId).delete()
        
        
    }

    
    @IBAction func cancelFriend(_ sender: Any) {
        
        mFirestore.collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("GelenKutusu").document(friends.senderId).delete()
        
        
    }
    

    
}
