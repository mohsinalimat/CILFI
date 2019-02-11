//
//  LastLoginModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੦/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import RealmSwift

class LastLoginModel : Object{
    
    @objc dynamic var username : String?
    @objc dynamic var company : String?
    @objc dynamic var password : String?
    @objc dynamic var hosted : String?
    
}
