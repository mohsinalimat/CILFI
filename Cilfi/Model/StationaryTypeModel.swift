//
//  StationaryTypeModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੪/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire


class StationaryTypeModel {
    
    
    func getStationaryType(completion : @escaping (([String], [String])->Void)){
        
        var aname = [String]()
        var acode = [String]()
        
        var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "T"]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/assetstype", method: .get, headers : header).responseJSON{
            response in
            
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
                //                                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let asset = try JSONDecoder().decode(AssetsTypeRoot.self, from: aData)
                    
                    for x in asset.asset{
                        
                        if let name = x.name{
                            aname.append(name)
                        }
                        if let code = x.code{
                            acode.append(code)
                        }
                        
                    }
                    
                    completion(acode,aname)
                    
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
        
        
    }
    
}
