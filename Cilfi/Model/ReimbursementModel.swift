//
//  ReimbursementModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 25/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SVProgressHUD

class ReimbursementModel{
    var reimburseType = [String]()
    var rName = [String]()
    var rCode = [String]()
    
    var name = [String]()
   
    let rRateURL = "\(LoginDetails.hostedIP)/sales/ReimbursementRate"
    let rTypeURL = "\(LoginDetails.hostedIP)/sales/ReimbursementType"
   
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getRTypeData(){
        
        rCode = [String]()
        reimburseType = [String]()
        rName = [String]()
        

        name = [String]()
        
        Alamofire.request(rTypeURL, headers: headers).responseJSON{
            response in
            
            
            let rTypeData = response.data!
            let rTypeJSON = response.result.value
            
            if response.result.isSuccess{
//                print(rTypeJSON)
                do{
                    let rType = try JSONDecoder().decode(ReimbursementTypeRoot.self, from: rTypeData)
                    
                    for x in rType.rType{
                        if let type = x.rtype{
                            self.reimburseType.append(type)
                        }
                        if let code = x.code{
                            self.rCode.append(code)
                            print(code)
                        }
                        
                        if let name = x.fn{
                            self.rName.append(name)
                        }
                        
                        if let name = x.name{
                            self.name.append(name)
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
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getRRateData(code : String, completion : @escaping((String)->Void) ){


        
            SVProgressHUD.show()
            let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")! , "code" : code]

            Alamofire.request("\(LoginDetails.hostedIP)/sales/ReimbursementRate", headers: header).responseJSON{
                response in


                let rRateData = response.data
                let rRateJSON = response.result.value

                if response.result.isSuccess{
//                    print(rRateJSON)
                    do{
                        let rate = try JSONDecoder().decode(ReimbursementRateRoot.self, from: rRateData!)


                        if let r8 = rate.rate{
                            
                            print(r8)
                            
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
