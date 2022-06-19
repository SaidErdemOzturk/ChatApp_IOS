//
//  ErrorMessage.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 13.05.2022.
//

import Foundation
import UIKit


func HataMesaji(Baslik : String, Hata : String,viewController : UIViewController) -> UIAlertController{
    let hataMesaji=UIAlertController(title: Baslik, message: Hata, preferredStyle: UIAlertController.Style.alert)
    let hataButton=UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
    hataMesaji.addAction(hataButton)
    return hataMesaji
}
