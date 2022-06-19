//
//  ProfileViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 25.03.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var adTextField: UITextField!
    @IBOutlet weak var soyadTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var resimImageView: UIImageView!
    
    
    
    let mFirestore = Firestore.firestore().collection("Kullanicilar")
    
    @objc func resimSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        resimImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resimImageView.layer.borderWidth = 1.0
        resimImageView.layer.borderColor = UIColor.gray.cgColor
        resimImageView.layer.cornerRadius = resimImageView.frame.height/3
        resimImageView.clipsToBounds = true
        
        resimImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resimSec))
        resimImageView.addGestureRecognizer(gestureRecognizer)
        
        
        let docRef = mFirestore.document(Auth.auth().currentUser!.uid).addSnapshotListener { documentSnapshot, error in
            if error != nil{
                self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
            }
            else{

                self.adTextField.text = (documentSnapshot?.get("displayName") as! String)
                self.soyadTextField.text = (documentSnapshot?.get("secondName") as! String)
                self.emailTextField.text = (documentSnapshot?.get("email") as! String)
                self.sifreTextField.text = (documentSnapshot?.get("password") as! String)
                self.resimImageView.sd_setImage(with: Auth.auth().currentUser?.photoURL, completed: nil)
            }
        }
    }
    var uuid = UUID().uuidString
    @IBAction func buttonGuncelle(_ sender: Any) {
        
        uuid = UUID().uuidString
        
        let imageReferance = Storage.storage().reference().child("images").child("\(uuid).jpg")
        
        if let data = resimImageView.image?.jpegData(compressionQuality: 0.5){
            
            
            imageReferance.putData(data, metadata: nil) { storageMetaData, error in
                if error != nil{
                    self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
                }else{
                    imageReferance.downloadURL { url, error in
                        if error != nil{
                            print(error!.localizedDescription)
                        }else{
                            let imageURL = url?.absoluteString
                            
                            self.mFirestore.document(Auth.auth().currentUser!.uid).updateData(["photoURL" : imageURL!])
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = URL(string: imageURL!)
                            
                            changeRequest?.commitChanges(completion: { error in
                                if error != nil{
                                    print(error!.localizedDescription)
                                }
                            })

                        }
                    }
                }
            }
        }
        if emailTextField.text != "" && sifreTextField.text != "" && adTextField.text != "" && soyadTextField.text != ""{
            Auth.auth().currentUser?.updateEmail(to: emailTextField.text!)
            Auth.auth().currentUser?.updatePassword(to: sifreTextField.text!)
            let docRef = mFirestore.document(Auth.auth().currentUser!.uid).updateData([
                "displayName":adTextField.text,
                "secondName":soyadTextField.text,
                "email":emailTextField.text,
                "password":sifreTextField.text])
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
