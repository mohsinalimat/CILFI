//
//  TeamDetailModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire


class TeamDetailModel{
    
    var employeeName = [String]()
    var employeeCode = [String]()
    
    func getTeamData(){
        
        employeeName = [String]()
        employeeCode = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/teamdetail", method: .get, headers : headers).responseJSON{
            response in
            
            let teamData = response.data!
            let teamJSON = response.result.value
            
            if response.result.isSuccess{
//                                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let team = try JSONDecoder().decode(TeamDetailRoot.self, from: teamData)
                    
                    for x in team.teamdetail{
                        
                        if let name = x.empName{
                            self.employeeName.append(name)
                        }
                        if let code = x.empCode{
                            self.employeeCode.append(code)
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
