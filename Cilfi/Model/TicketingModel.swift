//
//  TicketingModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TicketingApproveModel {
    
    static var dateTime : String?
    static var status = ""
    static var remark = ""
    static var ticketID = ""
  
}


class TicketingModel {
    
    
    var deptCode = [String]()
    var deptName = [String]()
    var catCode = [String]()
    var catName = [String]()
    var catEmail = [String]()
    var catSla = [String]()
    static var deptCode = ""
    static var catCode = ""

    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getDeptData for dropdown method here:
    
    func getDepartmentData(url : String) {
       
        deptCode = [String]()
        deptName = [String]()
        
//        var headers : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "deptcode" : TicketingModel.deptCode]
        
        Alamofire.request(url, method: .get, headers : headers).responseJSON{
            response in
            
            let deptDetailData = response.data!
            let deptDetailJSON = response.result.value
            
            if response.result.isSuccess{
                //                                print("UserJSON: \(userDetailJSON)")
                do{
                    let dept = try JSONDecoder().decode(TicketDeptCatRoot.self, from: deptDetailData)
                    
                    for x in dept.tdeptcategotyData{
                       
                        if let name = x.name{
                            self.deptName.append(name)
                        }
                        if let code = x.code{
                            self.deptCode.append(code)
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
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getDeptData for dropdown method here:
    
    func getCategoryData(url : String) {
        
         catCode = [String]()
         catName = [String]()
         catEmail = [String]()
         catSla = [String]()
       
        
                var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "deptcode" : TicketingModel.deptCode]
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let deptDetailData = response.data!
            let deptDetailJSON = response.result.value
            
            if response.result.isSuccess{
                //                                print("UserJSON: \(userDetailJSON)")
                do{
                    let dept = try JSONDecoder().decode(TicketDeptCatRoot.self, from: deptDetailData)
                    
                    for x in dept.tdeptcategotyData{
                        
                        if let name = x.name{
                            self.catName.append(name)
                        }
                        if let code = x.code{
                            self.catCode.append(code)
                        }
                        if let email = x.email{
                            self.catEmail.append(email)
                        }
                        if let sla = x.sla{
                            self.catSla.append(sla)
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
