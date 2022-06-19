//
//  Menu.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 10.05.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
class MenuListControllerr:UITableViewController{
    
    
    public var GelenKutusu : Array<Sender> = []
    
    override func viewDidLoad() {
        getGelenKutusu()
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
    }
    var items=["Profil","Arkadaşlarını Bul","Gelen Kutusu","Çıkış"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        if indexPath.row == 2{
            cell.textLabel?.text = "Gelen Kutusu (\(sayac))"
        }
        cell.backgroundColor = .systemGreen
        cell.textLabel?.textColor = .white
        return cell
    }
    
    
    var sayac = 0
    
    func getGelenKutusu() {
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("GelenKutusu").addSnapshotListener { querySnapshot, error in
            self.sayac = 0
            if error != nil{
                let alert=UIAlertController(title: "Hata", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{

                for _ in querySnapshot!.documents {
                    
                    self.sayac += 1
                    
                }
                self.tableView.reloadData()
                
            }
        }
    }
 
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let goBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.present(goBoard, animated: true, completion: nil)
        case 1:
            let goBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsAddViewController") as! FriendsAddViewController
            self.present(goBoard, animated: true, completion: nil)
            
        case 2:
            
            //Gelen kutusu bilgilerini çektiğimiz kısım

            let goBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GelenKutusuViewController") as! GelenKutusuViewController
            self.present(goBoard, animated: true, completion: nil)
        case 3:
            do{
                try Auth.auth().signOut()

                let goBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                self.present(goBoard, animated: true, completion: nil)
            }
            catch{
                print("bir sorun oluştu")
            }
            
        default:
            print("bir sorun oluştu")
        }
    }
}
