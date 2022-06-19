//
//  GruplarClass.swift
//  IOSProject
//
//  Created by Said Erdem Ozturk on 28.03.2022.
//

import Foundation
class Gruplar{
    var uid : String
    var ad : String
    var uyeler : Array<String>
    
    init(ad : String, uid : String, uyeler : Array<String>) {
        self.ad = ad
        self.uyeler = uyeler
        self.uid = uid
    }
}
