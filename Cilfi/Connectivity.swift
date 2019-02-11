//
//  Connectivity.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    class func connectionType() -> String{
        var connType = ""
        
        if NetworkReachabilityManager()!.isReachable{
            if NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi{
                connType = "wifi"
            }else if NetworkReachabilityManager()!.isReachableOnWWAN{
                connType =  "wwan"
            }
            
        }else{
            connType = "offline"
        }
        
        return connType
    }
    
}
