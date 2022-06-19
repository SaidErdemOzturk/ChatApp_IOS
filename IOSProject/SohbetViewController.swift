//
//  SohbetViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 21.03.2022.
//

import UIKit
import Firebase
import SideMenu
import SDWebImage
import FirebaseFirestore



class SohbetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var menu: SideMenuNavigationController?
    public var friendsList : Array<Sender> = []
    var friendsId : Array<String> = []

    @IBOutlet weak var tableView: UITableView!

    func getData(){
        
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Arkadaslar").addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.present(HataMesaji(Baslik: "Hata", Hata: error!.localizedDescription, viewController: self), animated: true, completion: nil)
            }else{
                self.friendsId = []
                self.friendsList = []
                for document in querySnapshot!.documents {
                    self.friendsId.append(document.get("senderId") as! String)
                }
                for item in self.friendsId{
                    Firestore.firestore().collection("Kullanicilar").document(item).addSnapshotListener { documentSnapshot, error in
                        
                        if error != nil{
                            self.present(HataMesaji(Baslik: "Hata", Hata: error!.localizedDescription, viewController: self), animated: true, completion: nil)
                        }else{
                            
                            //profil değişikliği olduğu zaman aynı kullanıcıdan 2 tane oluyordu. aşağıdaki kod ile bunu engelledik
                            
                            var sayac = 0
                            for item in self.friendsList {
                                if item.senderId ==  documentSnapshot!.get("senderId") as! String{
                                    self.friendsList.remove(at: sayac)
                                }
                                sayac += 1
                            }
                            self.friendsList.append(Sender(displayName: documentSnapshot!.get("displayName") as! String, email: documentSnapshot!.get("email") as! String, senderId: documentSnapshot!.get("senderId") as! String, photoURL: URL(string: documentSnapshot!.get("photoURL") as! String)!, secondName: documentSnapshot!.get("secondName") as! String))
                        }
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
    }

    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "resim"))
        getData()
        
        menu=SideMenuNavigationController(rootViewController: MenuListControllerr())
        SideMenuManager.default.rightMenuNavigationController=menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SohbetViewCell
        cell.adTextLabel.text = friendsList[indexPath.row].displayName
        cell.soyadTextLabel.text = friendsList[indexPath.row].secondName
        cell.sohbetImageView.sd_setImage(with: friendsList[indexPath.row].photoURL, completed: nil)
        cell.sohbetImageView.layer.masksToBounds = true;
        cell.sohbetImageView.layer.cornerRadius = cell.sohbetImageView.bounds.height/4
        cell.accessoryType = .disclosureIndicator//sağ ok
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.friend = Sender(displayName: friendsList[indexPath.row].displayName, email: friendsList[indexPath.row].email, senderId: friendsList[indexPath.row].senderId,photoURL: friendsList[indexPath.row].photoURL!, secondName: friendsList[indexPath.row].secondName)
        vc.title = vc.friend.displayName
        navigationController?.pushViewController(vc, animated: true)
        //performSegue(withIdentifier: "toMesajlar", sender: nil)
    }


    @IBAction func didTapMenu(){
        present(menu!, animated: true, completion: nil)
    }
    
}
