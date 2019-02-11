//
//  AssetsApprovalModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੨/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AssetsApprovalModel{
    
    func setData(assetType: String, params : [Any], completion : @escaping (JSON)->Void){
        
        let header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : assetType]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AssetsApproval" , method : .post,  parameters : ["assetsData":params], encoding: JSONEncoding.default , headers: header).responseJSON{
            response in
            
            print(params)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                
                completion(loginJSON["returnType"])
                
                
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
        
        
    }
    
    
    
    func setIssueData(assetType: String, params : [Any], completion : @escaping (JSON)->Void){
        
        let header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : assetType]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AssetsIssue" , method : .post,  parameters : ["assetsData":params], encoding: JSONEncoding.default , headers: header).responseJSON{
            response in
            
            print(params)
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                
                
                completion(loginJSON["returnType"])
                
                
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
        
        
    }
    
}

