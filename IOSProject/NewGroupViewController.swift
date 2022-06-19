//
//  NewGroupViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 15.05.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewGroupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    var user = Sender(displayName: "", email: "", senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    var friendsId : Array<String> = []
    var friends : Array<Sender> = []
    var groupUser : Array<Dictionary<String,String>> = []
    var grup = Gruplar(ad: "", uid: "", uyeler: [])
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var grupAdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isHidden = true
        //tableView.isHidden = true
        friends = []
        friendsId = []
        grup = Gruplar(ad: "", uid: "", uyeler: [])
        groupUser = []
        getData()

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).getDocument { documentSnapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                self.user.displayName=documentSnapshot?.get("displayName") as! String
                self.user.email=documentSnapshot?.get("email") as! String
                self.user.secondName=documentSnapshot?.get("secondName") as! String
                self.user.senderId=Auth.auth().currentUser!.uid
                self.user.photoURL = URL(string: documentSnapshot?.get("photoURL") as! String)
            }
            self.tableView.reloadData()
        }
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Arkadaslar").addSnapshotListener { querySnapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                
                for document in querySnapshot!.documents {
                    self.friendsId.append(document.get("senderId") as! String)
                }
                for item in self.friendsId {
                    Firestore.firestore().collection("Kullanicilar").document(item).addSnapshotListener { documentSnapshot, error in
                        if error != nil{
                            print(error!.localizedDescription)
                        }else{
                            self.friends.append(Sender(displayName: documentSnapshot!.get("displayName") as! String, email: documentSnapshot!.get("email") as! String, senderId: documentSnapshot!.get("senderId") as! String, photoURL: URL(string: documentSnapshot!.get("photoURL") as! String)!, secondName: documentSnapshot!.get("secondName") as! String))
                        }
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
        
    }
 
    var uuid = UUID()
    var control = false
    var grupString = ""
    @IBAction func createGroup(_ sender: Any) {
        
        
        if grupAdTextField.text != nil {
            grup.uyeler.append(user.senderId)
            uuid = UUID()
            grup.uid = uuid.uuidString
            grup.ad = grupAdTextField.text!
            control = true
            Firestore.firestore().collection("Kullanicilar").document(user.senderId).collection("Gruplar").document(grup.uid).setData(["Kullanicilar" : grup.uyeler,"grupAdi":grup.ad,"grupId":grup.uid])
            tableView.reloadData()
        }else{
            self.present(HataMesaji(Baslik : "Hata", Hata: "Grup adı giriniz", viewController: self), animated: true, completion: nil)
        }
       
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewGroupTableViewCell
        cell.adTextLabel.text = friends[indexPath.row].displayName
        cell.soyadTextLabel.text=friends[indexPath.row].secondName
        cell.friend = friends[indexPath.row].senderId
        cell.group = grup
        cell.friends = friends

        return cell
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
