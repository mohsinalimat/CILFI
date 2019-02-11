//
//  LoanApprovalModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੭/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON



class LoanApprovalModel{
    
    
    func setLoanApprovalModal(params : [String: Any], completion : @escaping (JSON)->Void ){
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Loanapproval" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
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

