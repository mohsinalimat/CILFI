//
//  CustomerModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 25/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

class CustomerModel {
    
    var custName = [String]()
    var custCode =  [String]()
    
    
    func getCustomerData(){
        
        custName = [String]()
        custCode =  [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Customer", method: .get, headers : headers).responseJSON{
            response in
            
            let ledgerData = response.data!
            let ledgerJSON = response.result.value
            
            if response.result.isSuccess{
                //                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let ledger = try JSONDecoder().decode(LedgerAccountRoot.self, from: ledgerData)
                    
                    for x in ledger.customerData{
                        
                        if let code = x.custCode{
                            self.custCode.append(code)
                        }
                        if let name = x.custName{
                            self.custName.append(name)
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
