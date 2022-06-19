//
//  SohbetViewCell.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 25.04.2022.
//

import UIKit

class SohbetViewCell: UITableViewCell {

    @IBOutlet weak var sohbetImageView: UIImageView!
    
    @IBOutlet weak var adTextLabel: UILabel!
    
    @IBOutlet weak var soyadTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
