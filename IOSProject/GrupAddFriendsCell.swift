//
//  GrupAddFriendsCell.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 10.05.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
class GrupAddFriendsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var adTextLabel: UILabel!
    
    @IBOutlet weak var soyadTextLabel: UILabel!
    
    @IBOutlet weak var isFriend: UISwitch!
    var friend = ""
    var group = Gruplar(ad: "", uid: "", uyeler: [])
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func isFrendAction(_ sender: Any) {
        
        if isFriend.isOn == true {
            group.uyeler.append(friend)
            for item in group.uyeler {
                Firestore.firestore().collection("Kullanicilar").document(item).collection("Gruplar").document(group.uid).setData(["Kullanicilar" : group.uyeler,"grupAdi":group.ad,"grupId":group.uid])
            }

        }else{
            var sayac = 0
            for item in group.uyeler {
                if item == group.uyeler[sayac] {
                    group.uyeler.remove(at: sayac)
                    break
                }
                sayac += 1
            }
            for item2 in group.uyeler {
                Firestore.firestore().collection("Kullanicilar").document(item2).collection("Gruplar").document(group.uid).updateData(["Kullanicilar" : group.uyeler])
            }
            Firestore.firestore().collection("Kullanicilar").document(friend).collection("Gruplar").document(group.uid).delete()
            
        }
        
    }
    
}
