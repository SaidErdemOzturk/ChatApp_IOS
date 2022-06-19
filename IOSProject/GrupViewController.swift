//
//  GrupViewController.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 21.03.2022.
//

import UIKit
import Firebase
import SideMenu
import FirebaseFirestore

class GrupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var grup = Gruplar(ad: "", uid: "", uyeler: [])
    var popup = UIMenu()
    var group: Array<Gruplar> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)//gerekli yoksa veri iletilemiyor
        
        let vc = GroupChatViewController()
        vc.grup = Gruplar(ad: group[indexPath.row].ad, uid: group[indexPath.row].uid, uyeler: group[indexPath.row].uyeler)
        vc.title = vc.grup.ad
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! GrupViewCellTableViewCell
        
        let addUserItem = UIAction(title: "Arkadaş Ekle/Çıkart", image: UIImage(systemName: "person.badge.plus")) { (action) in
            self.grup = self.group[indexPath.row]
            self.performSegue(withIdentifier: "toGrupAddFriends", sender: nil)
        }

        let deleteGroup = UIAction(title: "Grubu Sil", image: UIImage(systemName: "trash.fill")) { (action) in
            self.present(HataMesaji(Baslik: "Grup Silindi", Hata: self.group[indexPath.section].uid, viewController: self), animated: true, completion: nil)
            Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").document(self.group[indexPath.section].uid).delete()
        }
        cell.menu = UIMenu(title: "Menü", options: .displayInline, children: [deleteGroup , addUserItem])
        cell.grupTextLabel.text=group[indexPath.row].ad
        return cell
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grup = Gruplar(ad: "", uid: "", uyeler: [])
        group = []
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        menu=SideMenuNavigationController(rootViewController: MenuListControllerr())
        SideMenuManager.default.rightMenuNavigationController=menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    func getData(){
        Firestore.firestore().collection("Kullanicilar").document(Auth.auth().currentUser!.uid).collection("Gruplar").addSnapshotListener { querySnapshot, error in
            if error != nil{
                self.present(HataMesaji(Baslik: "Hata", Hata: error?.localizedDescription ?? "Bilinemeyen bir hata oluştu.", viewController: self), animated: true, completion: nil)
            }else{
                self.group = []
                for document in querySnapshot!.documents {
                    if querySnapshot?.documents != nil{
                        self.group.append(Gruplar(ad: document.get("grupAdi") as! String, uid: document.get("grupId") as! String, uyeler: document.get("Kullanicilar") as! Array<String>))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGrupAddFriends" {
            let destVC = segue.destination as! GrupAddFriendsViewController
            destVC.grup = grup
        }
    }
    
    
    @IBAction func grupOlustur(_ sender: Any) {
        performSegue(withIdentifier: "toNewGroup", sender: nil)
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
