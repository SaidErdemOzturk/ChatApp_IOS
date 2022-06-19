//
//  KayitViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 23.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
class KayitViewController: UIViewController {

    @IBOutlet weak var adTextField: UITextField!
    @IBOutlet weak var soyadTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    let mFirestore=Firestore.firestore()
    let imageURL : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func kayitButton(_ sender: Any) {

        if adTextField.text == "" || soyadTextField.text == "" || emailTextField.text == "" || sifreTextField.text == "" {
        
            self.present(HataMesaji(Baslik: "Hata", Hata: "Lütfen boş alan bırakmayınız", viewController: self), animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { AuthDataResult, error in
                if error != nil{
                    
                    self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
                }
                else{
                    let imageReferance = Storage.storage().reference().child("images").child("default.jpg")
                    
                    imageReferance.downloadURL { url, error in
                        if error != nil{
                            self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
                        }else{
                            let imageURL = url?.absoluteString
                            self.mFirestore.collection("Kullanicilar").document("\(Auth.auth().currentUser!.uid)").setData([
                                "displayName": self.adTextField.text!,
                                "secondName": self.soyadTextField.text!,
                                "email": self.emailTextField.text!,
                                "password": self.sifreTextField.text!,
                                "photoURL":imageURL!,
                                "senderId":Auth.auth().currentUser!.uid
                            ])
                            self.performSegue(withIdentifier: "createTOmain", sender: nil)
                        }
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
