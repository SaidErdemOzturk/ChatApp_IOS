//
//  FriendsAddViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 25.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class FriendsAddViewController: UIViewController {
    var friendsListId : Array<String> = []
    var friendsList : Array<Sender> = []
    var friendsID : String = ""
    var uye = Sender(displayName: "", email: "", senderId: "", photoURL: URL(string: "www.example.com")!, secondName: "")
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var adTextLabel: UILabel!
    @IBOutlet weak var soyadTextLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    let mFirestore = Firestore.firestore().collection("Kullanicilar")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mFirestore.document(Auth.auth().currentUser!.uid).collection("Arkadaslar").getDocuments { querySnapshot, error in
            if error != nil{
                
            }else{
                if querySnapshot?.documents != nil {
                    self.friendsListId.removeAll()
                    for document in querySnapshot!.documents {
                        self.friendsListId.append(document.get("senderId") as! String)
                    }
                    for item in self.friendsListId {
                        
                        self.mFirestore.document(item).getDocument { documentSnapshot, error in
                            if error != nil{
                                
                            }else{
                                self.friendsList.append(Sender(displayName: documentSnapshot?.get("displayName") as! String, email: documentSnapshot?.get("email") as! String, senderId: documentSnapshot?.get("senderId") as! String, photoURL: URL(string: documentSnapshot?.get("photoURL")! as! String)! , secondName: documentSnapshot?.get("secondName") as! String))
                            }
                        }
                    }
                }

            }
        }
        mFirestore.document(Auth.auth().currentUser!.uid).getDocument { DocumentSnapshot, error in
            if error != nil{
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.uye.displayName = DocumentSnapshot?.get("displayName") as! String
                self.uye.secondName = DocumentSnapshot?.get("secondName") as! String
                self.uye.email = DocumentSnapshot?.get("email") as! String
                self.uye.senderId = Auth.auth().currentUser!.uid
                self.uye.photoURL = URL(string: DocumentSnapshot?.get("photoURL") as! String)!
            }
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func searchButton(_ sender: Any) {
        var control = false
        if emailTextField.text != "" {
            if emailTextField.text == Auth.auth().currentUser!.email {
                self.present(HataMesaji(Baslik: "Arkadas isteği", Hata: "Kendini ekleyemezsin", viewController: self), animated: true, completion: nil)
            }else{
                
                for item in friendsList {
                    if item.email == emailTextField.text {
                        control = true
                    }
                }
                if control == false {
                    mFirestore.whereField("email", isEqualTo: emailTextField.text!).getDocuments { querySnapshot, error in
                        if error != nil{
                            
                        }else{
                            if querySnapshot?.documents.isEmpty == true {
                                self.present(HataMesaji(Baslik: "Arkadas isteği", Hata: "Böyle bir arkadaş bulunamadı.", viewController: self), animated: true, completion: nil)
                            }else{
                                for document in querySnapshot!.documents {
                                    self.friendsID = document.get("senderId") as! String
                                    self.adTextLabel.text! = document.get("displayName") as! String
                                    self.soyadTextLabel.text! = document.get("secondName") as! String
                                    self.adTextLabel.isHidden = false
                                    self.soyadTextLabel.isHidden = false
                                    self.button.isHidden = false
                                }
                            }

                        }
                    }
                }else{
                    self.present(HataMesaji(Baslik: "Arkadas isteği", Hata: "Bu kişi zaten Arkadaşın", viewController: self), animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    @IBAction func addButton(_ sender: Any) {

        self.mFirestore.document(friendsID).collection("GelenKutusu").document(Auth.auth().currentUser!.uid).setData([
                                                                                                    "displayName":uye.displayName,
                                                                                                    "secondName":uye.secondName,
                                                                                                    "email":uye.email,
                                                                                                    "senderId":uye.senderId,
                                                                                                                        "photoURL":uye.photoURL!.absoluteString])
        self.present(HataMesaji(Baslik: "Arkadas isteği", Hata: "Arkadaş isteği gönderme başarılı", viewController: self), animated: true, completion: nil)
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
