//
//  ManagerModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 22/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

struct ManagerInfo{
    static var isManager = ""
    static var managerCode = ""
    static var managerName = ""
    static var upperManagerCode = ""
    static var upperManagerName = ""

}


class ManagerModel{
    
    
    func getManagerDetails(){
        
        ManagerInfo.isManager = ""
        ManagerInfo.managerCode = ""
        ManagerInfo.managerName = ""
        ManagerInfo.upperManagerCode = ""
        ManagerInfo.upperManagerName = ""
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/manager", method: .get, headers : headers).responseJSON {
            response in
            
            let managerData = response.data!
            let managerJSON = response.result.value
            
            if response.result.isSuccess{
                //                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let manager = try JSONDecoder().decode(ManagerRoot.self, from: managerData)
                    
                    if let value = manager.isManager{
                       ManagerInfo.isManager = value
                    }
                    
                    if let value = manager.managerCode{
                        ManagerInfo.managerCode = value
                    }
                    
                    if let value = manager.managerName{
                        ManagerInfo.managerName = value
                    }
                    
                    if let value = manager.upperManagerCode{
                        ManagerInfo.upperManagerCode = value
                    }
                    if let value = manager.upperManagerName{
                        ManagerInfo.upperManagerName = value
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



