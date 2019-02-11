//
//  PersonalProfileModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 07/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class PersonalProfileModel{
   
    var title = [String]()
    var values = [String]()
    
    
    func getPersonalProfileData(){
       title = [String]()
       values = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/EmployeeProfile", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let epData = response.data!
            let epJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let ep = try JSONDecoder().decode(EmployeeProfileRoot.self, from: epData)
                    
                    for x in ep.empProfile{
                        
                        if let title = x.title{
                            self.title.append(title)
                        }
                        if let value = x.value{
                            self.values.append(value)
                        }
                    }
                    
                    SVProgressHUD.dismiss()
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
