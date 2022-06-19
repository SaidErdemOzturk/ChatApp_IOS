//
//  GrupViewCellTableViewCell.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 10.05.2022.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseFirestore

class GrupViewCellTableViewCell: UITableViewCell {
    var menu = UIMenu()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
            

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var grupTextLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBAction func settingGrup(_ sender: Any) {
        settingButton.menu = menu
        settingButton.showsMenuAsPrimaryAction = true
    }
    
    
}
