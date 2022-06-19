//
//  GelenKutusuViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 26.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class GelenKutusuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    
    @IBOutlet weak var tableView: UITableView!

    let mFirestore = Firestore.firestore().collection("Kullanicilar")
    
    var friendsId : Array<String> = []
    var array : Array<Sender> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GelenKutusuCell
        cell.friends=array[indexPath.row]
        cell.adTextLabel.text = cell.friends.displayName
        cell.soyadTextLabel.text = cell.friends.secondName
        cell.emailTextLabel.text = cell.friends.email
        return cell
        
    }
    
    func getData(){
        mFirestore.document(Auth.auth().currentUser!.uid).collection("GelenKutusu").addSnapshotListener { querySnapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                self.array = []
                self.friendsId = []
                for document in querySnapshot!.documents {
                    if document.exists == true {
                        self.friendsId.append(document.get("senderId") as! String)
                    }
                }
                
                for item in self.friendsId {
                    self.mFirestore.document(item).addSnapshotListener { documentSnapshot, error in
                        if error != nil{
                            print(error!.localizedDescription)
                        }else{
                            self.array.append(Sender(displayName: documentSnapshot!.get("displayName") as! String, email: documentSnapshot!.get("email") as! String, senderId: documentSnapshot!.get("senderId") as! String, photoURL: URL(string: documentSnapshot!.get("photoURL") as! String)!, secondName: documentSnapshot!.get("secondName") as! String))
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

