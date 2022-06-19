//
//  ViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 20.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    let mFirestore=Firestore.firestore()
    var sohbetArray : Array<Sender> = []
    var grupArray : Array<Sender> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonKayit(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreatVC", sender: nil)
    }
    
    @IBAction func buttonGiris(_ sender: Any) {
        if eMail.text != "" && password.text != "" {
            Auth.auth().signIn(withEmail: eMail.text!, password: password.text!) { authDataResult, error in
                print(Auth.auth().currentUser!.uid)
                if error != nil{
                    self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
                }
                else{
                    self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    
                }
            }
            
        }
            else{
                self.present(HataMesaji(Baslik: "Hata", Hata: "Email veya şifreyi boş bırakmayınız.", viewController: self), animated: true, completion: nil)
        }

    }
}


