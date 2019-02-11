//
//  LoginModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 15/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:- Offline Login Class

class Login: Object {
    @objc dynamic var user = ""
    @objc dynamic var pass = ""
    @objc dynamic var company = ""
    @objc dynamic var yearMonth = ""
    @objc dynamic var empCode = ""
    
    @objc dynamic var trackTime = ""
    @objc dynamic var distance = ""
    @objc dynamic var email = ""
    @objc dynamic var longitude = ""
    @objc dynamic var latitude = ""
    @objc dynamic var loginStatus = ""
    @objc dynamic var imgUrl = ""
    @objc dynamic var designation = ""
    @objc dynamic var compURL = ""
    @objc dynamic var name = ""
    @objc dynamic var routeDistance = ""
    @objc dynamic var stayTime = ""
    @objc dynamic var trackingStatus = ""
    @objc dynamic var ghostSelfie = ""
}


