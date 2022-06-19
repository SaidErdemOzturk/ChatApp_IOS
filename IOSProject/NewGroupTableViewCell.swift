//
//  NewGroupTableViewCell.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 15.05.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewGroupTableViewCell: UITableViewCell{
    var friend = ""
    var friends : Array<Sender> = []
    var group = Gruplar(ad: "", uid: "", uyeler: [])
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    
    @IBOutlet weak var adTextLabel: UILabel!
    
    @IBOutlet weak var inGroup: UISwitch!
    
    @IBOutlet weak var soyadTextLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inGroupAction(_ sender: Any) {
        if group.uid == "" {
            inGroup.isOn = false
            
        }else{
            if inGroup.isOn == true {
                group.uyeler.append(friend)

                Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").document(group.uid).updateData(["Kullanicilar" : group.uyeler])
                print(friend)
                Firestore.firestore().collection("Kullanicilar").document(friend).collection("Gruplar").document(group.uid).setData(["Kullanicilar" : group.uyeler,"grupAdi":group.ad,"grupId":group.uid])
            }else{
                var sayac = 0
                for item in group.uyeler {
                    if item == friend {
                        group.uyeler.remove(at: sayac)
                        break
                    }
                    sayac += 1
                }
                Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").document(group.uid).updateData(["Kullanicilar" : group.uyeler])
                Firestore.firestore().collection("Kullanicilar").document(friend).collection("Gruplar").document(group.uid).delete()
                
            }
        }
        
        
    }
    
}
