//
//  ReimbursementLedgerModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 11/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire


class ReimbursementLedgerModel{
    
    var groupType = [String]()
    
    func getLedgerGroupTypeData(empCode : String){
        
        groupType = [String]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        
        var header : [String:String]?
        
        
        if empCode == ""{
            header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "fromdate" : "2018/1/1", "todate":formatter.string(from: Date())]
        }
        else{
            header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : empCode, "fromdate" : "2018/1/1", "todate":formatter.string(from: Date())]
        }
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementLedger", method: .get, headers : header).responseJSON{
            response in
            
            let ledgerData = response.data!
            let ledgerJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let ledger = try JSONDecoder().decode(ReimbursementLedgerRoot.self, from: ledgerData)
                    
                    
                    for x in ledger.rlgList{
                        
                        if let type = x.groupTitle{
                            self.groupType.append(type)
                        }
                        
                    }
                    
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
