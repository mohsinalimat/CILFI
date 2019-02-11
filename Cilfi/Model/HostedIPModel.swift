//
//  HostedIPModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 07/09/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift



class HostedIP: Object{

    @objc dynamic var code = ""
    @objc dynamic var hostedIP = ""
    @objc dynamic var shortName = ""
    @objc dynamic var fullName = ""
    
}



