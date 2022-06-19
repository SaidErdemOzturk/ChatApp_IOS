//
//  GrupAddFriendsViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 13.05.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class GrupAddFriendsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    var grup = Gruplar(ad: "", uid: "", uyeler: [])
    var friendsId : Array<String> = []
    var friends : Array<Sender> = []
    var groupsFriends : Array<String> = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GrupAddFriendsCell
        cell.adTextLabel.text = friends[indexPath.row].displayName
        cell.soyadTextLabel.text = friends[indexPath.row].secondName
        for item in groupsFriends {
            if item == friends[indexPath.row].senderId {
                cell.isFriend.setOn(true, animated: true)
            }
        }
        cell.friend = friends[indexPath.row].senderId
        cell.group = grup
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource=self
        
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").document(grup.uid).addSnapshotListener { DocumentSnapshot, error in
            if error != nil{
                self.present(HataMesaji(Baslik: "Hata", Hata: error!.localizedDescription, viewController: self), animated: true, completion: nil)
            }else{
                self.groupsFriends = DocumentSnapshot!.get("Kullanicilar") as! Array<String>
                
            }
            self.tableView.reloadData()
        }
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Arkadaslar").addSnapshotListener { querySnapshot, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                
                for document in querySnapshot!.documents {
                    self.friendsId.append(document.get("senderId") as! String)
                }
                for item in self.friendsId {
                    Firestore.firestore().collection("Kullanicilar").document(item).addSnapshotListener { documentSnapshot, error in
                        if error != nil{
                            print(error?.localizedDescription)
                        }else{
                            self.friends.append(Sender(displayName: documentSnapshot!.get("displayName") as! String, email: documentSnapshot!.get("email") as! String, senderId: documentSnapshot!.get("senderId") as! String, photoURL: URL(string: documentSnapshot!.get("photoURL") as! String)!, secondName: documentSnapshot!.get("secondName") as! String))
                        }
                        self.tableView.reloadData()
                        
                    }
                }
            }
            
        }
        
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
