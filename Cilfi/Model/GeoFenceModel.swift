//
//  GeoFenceModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 02/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

@available(iOS 10.0, *)
class GeoFenceModel{

    var empName = [String]()
    var empCode = [String]()
    var distance = [Int]()
    var lat = [Double]()
    var lng = [Double]()
    var allowGeo = [String]()
    var fenceCode = [String]()
    var allow = "N"
    
    func getFenceData(){
        
         empName = [String]()
         empCode = [String]()
         distance = [Int]()
         lat = [Double]()
         lng = [Double]()
         allowGeo = [String]()
         fenceCode = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/geofencing", method: .get, headers : headers).responseJSON{
            response in
            
            
            let fencingData = response.data!
            let fenceJSON = response.result.value
            if response.result.isSuccess{
//                print("FenceJSON: \(fenceJSON)")
                do{
                    let fence = try JSONDecoder().decode(FencingRoot.self, from: fencingData)
                   
                    if let allow = fence.allowGeo{
                        
                        if allow == "Y"{
                            self.allow = allow
                            for x in fence.fenceDetails{
                                
                                if let name = x.empName{
                                    self.empName.append(name)
                                }
                                if let code = x.empCode{
                                    self.empCode.append(code)
                                }
                                if let dis = x.distance{
                                    self.distance.append(dis)
                                }
                                if let lat = x.lat{
                                    self.lat.append(lat)
                                }
                                if let long = x.lng{
                                    self.lng.append(long)
                                }
                                if let allowgeo = x.allowGeo{
                                    self.allowGeo.append(allowgeo)
                                }
                                if let fCode = x.fenceCode{
                                    self.fenceCode.append(fCode)
                                }
                            }
                        }
                    }
                    
                    MarkAttendanceController.bgFetch = false
                }catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
    }
    
}
