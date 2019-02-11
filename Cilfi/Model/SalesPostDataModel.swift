//
//  SalesPostDataModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 24/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD


class SalesPostDataModel {
    
func postSalesData(url : String , item : Any, completion : @escaping (String)->Void){
    
    let parameter = ["itemPost":item]
    let ip = whatIsIP()
    var menuIndex = ""
    
    
    for index in 1...Category.sub.count{
        if Category.sub[index-1] == menuNameForIndex{
            menuIndex = Category.subMenuID[index-1]
        }
    }
    
    var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "ipaddress" : ip, "menuindex" : menuIndex]
    
    
    print(parameter)
    Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
        response in
        
        
        let loginJSON : JSON = JSON(response.result.value)
        
        if response.result.isSuccess{
//            print("Success! Posting the Leave Request data")
            
            if let returnType = loginJSON["returnType"].string{
                completion(returnType)
            }
            
            
           
        }
            
        else{
            
            print(loginJSON)
            
        }
        
        
    }
    
   
    
}

    
}
