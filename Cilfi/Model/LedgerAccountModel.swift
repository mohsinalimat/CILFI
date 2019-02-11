//
//  LedgerAccountModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 16/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

var custName = [String]()

class LedgerAccountModel{
    
    
    var custCode = [String]()
    var address1 = [String]()
    var address2 = [String]()
    var address3 = [String]()
    var city = [String]()
    var district = [String]()
    var state = [String]()
    var pincode = [String]()
    
    func getCustomerData(){
        
        
        custCode = [String]()
        address1 = [String]()
        address2 = [String]()
        address3 = [String]()
        city = [String]()
        district = [String]()
        state = [String]()
        pincode = [String]()
        
        
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
                        if let add1 = x.custAddress1{
                            self.address1.append(add1)
                        }
                        if let add2 = x.custAddress2{
                            self.address2.append(add2)
                        }
                        if let add3 = x.custAddress3{
                            self.address3.append(add3)
                        }
                        
                        if let city = x.city{
                            self.city.append(city)
                        }
                        if let state = x.state{
                            self.state.append(state)
                            
                        }
                        if let dist = x.dist{
                            self.district.append(dist)
                        }
                        if let pin = x.pin{
                            self.pincode.append(pin)
                        }
                    }
                    
//                    print(self.custCode)
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
    
    
    func getCustomerNameData(){
    
        custName = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Customer", method: .get, headers : headers).responseJSON{
            response in
            
            let ledgerData = response.data!
            let ledgerJSON = response.result.value
            
            if response.result.isSuccess{
//                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let ledger = try JSONDecoder().decode(LedgerAccountRoot.self, from: ledgerData)
                    
                    for x in ledger.customerData{
                        
                        
                        if let name = x.custName{
                            custName.append(name)
                        }
                       
                    }
                    
                    print(self.custCode)
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
