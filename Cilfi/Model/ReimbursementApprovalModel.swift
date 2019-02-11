//
//  ReimbursementApprovalModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੯/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ReimbursementApprovalModel{
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func status(dType: String, empCode: String, expensedate: String, ltype: String, mgrremarks: String, mgrStatus: String, rowseq : String, approvedAmmount : String, approvedKms : String, completion: @escaping (String)->Void){
        //        {"mgrReimburse":[{"Dtyp":"03","EmpCode":"r35","ExpenseDate":"2017-11-19","Ltyp":"02","MgrRemark":"","MgrStatus":"Y"}
        
        let parameters : [String:[Any]] = [ "mgrReimburse" : [["Dtyp" : dType, "EmpCode": empCode,"ExpenseDate":expensedate, "Ltyp":ltype, "MgrRemark":mgrremarks, "MgrStatus":mgrStatus, "RowSeq": rowseq, "ApprovedAmount":approvedAmmount,"ApprovedKms":approvedKms ]]]
        
        
        
                print(parameters)
        Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementApproval" , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Detail data")
               
                completion(loginJSON["returnType"].string!)
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func statusforAcceptRejectBtn(params : [Any], completion: @escaping (String)->Void){
        //        {"mgrReimburse":[{"Dtyp":"03","EmpCode":"r35","ExpenseDate":"2017-11-19","Ltyp":"02","MgrRemark":"","MgrStatus":"Y"}
        
        let parameters : [String:[Any]] = [ "mgrReimburse" : params]
        
        
        
//        print(parameters)
        Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementApproval" , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Detail data")
                
                completion(loginJSON["returnType"].string!)
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    

}

