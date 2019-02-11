//
//  TrackAllModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire

class TrackAllModel{
    
    var empName  = [String]()
    var empCode  = [String]()
    var checkDate  = [String]()
    var latitude  = [String]()
    var longitude  = [String]()
    var macAddress  = [String]()
    var imei  = [String]()
    var address  = [String]()
    var simNumber  = [String]()
    var checkType  = [String]()
    var meters  = [String]()
    var imgUrl  = [String]()
    var batterySatus  = [Int]()
    var locationMode  = [String]()
    
    func getTrackAllData(){
        
        empName  = [String]()
        empCode  = [String]()
        checkDate  = [String]()
        latitude  = [String]()
        longitude  = [String]()
        macAddress  = [String]()
        imei  = [String]()
        address  = [String]()
        simNumber  = [String]()
        checkType  = [String]()
        meters  = [String]()
        imgUrl  = [String]()
        batterySatus  = [Int]()
        locationMode  = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/trackall", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let trackAllData = response.data!
            let trackAllJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let trackAll = try JSONDecoder().decode(TrackAllRoot.self, from: trackAllData)
                    let dateFormatter = DateFormatter()
                    
                    for x in trackAll.taData{
                        
                        if let name = x.empName{
                            self.empName.append(name)
                        }
                        if let code = x.empCode{
                            self.empCode.append(code)
                        }
                        if let date = x.checkDate{
                            self.checkDate.append(date)
                        }
                        if let lat = x.latitude{
                            self.latitude.append(lat)
                        }
                        if let lng = x.longitude{
                            self.longitude.append(lng)
                        }
                        if let mac = x.macAddress{
                            self.macAddress.append(mac)
                        }
                        if let imeiNo = x.imei{
                            self.imei.append(imeiNo)
                        }
                        if let address = x.address{
                            self.address.append(address)
                        }
                        if let sim = x.simNumber{
                            self.simNumber.append(sim)
                        }
                        if let check = x.checkType{
                            self.checkType.append(check)
                        }
                        if let meter = x.meters{
                            self.meters.append(meter)
                        }
                        if let imgURL = x.imgUrl{
                            self.imgUrl.append(imgURL)
                        }
                        if let battery = x.batterySatus{
                            self.batterySatus.append(battery)
                        }
                        if let loc = x.locationMode{
                            self.locationMode.append(loc)
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
