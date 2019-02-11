//
//  MarkAttendenceModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import CoreLocation
import SVProgressHUD
import SwiftyJSON

class MarkAttendance: Object{
    
    @objc dynamic var attenMode = "Offline"
    @objc dynamic var checkDate = ""
    @objc dynamic var checkTime = ""
    @objc dynamic var checkType = ""
    @objc dynamic var inOut = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
    @objc dynamic var batteryStatus = 0
    @objc dynamic var ghostImg = ""
    @objc dynamic var locMode = "No Network"
    @objc dynamic var user = ""
    @objc dynamic var company = ""
    
}

class MarkAttendenceModel{
    let realm = try! Realm()
    
//    var timer = Timer()
    var checkDate = ""
    var checkTime = ""
    var inOut = ""
    
    static var address = [String]()
    static var pin = [String]()
    static var city = [String]()
    static var state = [String]()
    
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!) + "hrs"
        
        checkTime = String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        checkDate = String(year!) + "-" + String(month!) + "-" + String(day!)
        
        return today_string
        
    }
    
    
    
    
    func fetchOfflineAddress(){
        
        MarkAttendenceModel.address = [String]()
        MarkAttendenceModel.pin = [String]()
        MarkAttendenceModel.city = [String]()
        MarkAttendenceModel.state = [String]()
        
        let attnd = realm.objects(MarkAttendance.self).filter("user == %@ AND company == %@", defaults.string(forKey: "user")!, defaults.string(forKey: "company")!)
        
        if attnd.count != 0{
            for x in 1...attnd.count{
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(CLLocation(latitude: attnd[x-1].lat, longitude: attnd[x-1].lng), completionHandler: { (placemark, error) in
                    
                    if let pm = placemark{
                        
                        let address1 = pm[0].thoroughfare ?? ""
                        let address2 = pm[0].subThoroughfare ?? ""
                        let city = pm[0].locality ?? ""
                        let state = pm[0].administrativeArea ?? ""
                        let pin =  pm[0].postalCode ?? ""
                        let country =  pm[0].country ?? ""
                        
                        let add = "\(address1), \(address2), \(city), \(state), \(pin), \(country)"
                        print(add)
                        MarkAttendenceModel.address.append(add)
                        MarkAttendenceModel.pin.append(pm[0].postalCode ?? "")
                        MarkAttendenceModel.city.append(pm[0].locality ?? "")
                        MarkAttendenceModel.state.append(pm[0].administrativeArea ?? "")
                    }
                    
                })
            }
        }
    }
    
    
    func setOfflineAttendanceData(url : String, header : [String:String], parameter : [String:[Any]]){
        DispatchQueue.main.async {
            let offattnd = self.realm.objects(MarkAttendance.self).filter("user == %@ AND company == %@", defaults.string(forKey: "user")!, defaults.string(forKey: "company")!)
            
            if offattnd.count != 0{
                
                
//                            print(parameter)
                Alamofire.request(url , method : .post,  parameters : parameter, encoding: JSONEncoding.default , headers: header).responseJSON{
                    response in
                    
                    //                        print(response)
                   
                    
                    //
                    let loginJSON : JSON = JSON(response.result.value)
                    
    
                    if response.result.isSuccess{
//                        print(loginJSON)
                        
                        if loginJSON["returnType"].string == "Attendance mark successfully"{
                            SVProgressHUD.showSuccess(withStatus: "Offline Attendance marked successfully")
                            try! self.realm.write{
                                self.realm.delete(offattnd)
                            }
                        }else{
                            SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                        }
                        
                    }
                        
                    else{
                        //print("Error: \(response.result.error!)")
                        print(loginJSON)
                    }
                    
                }
            }
        }
                
    }
            
            

    func getLastAttendanceInOut(completion : @escaping (String,String)->Void){
        
        var lastIn = ""
        var lastOut = ""
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AttendanceLastInOutTime", headers: headers).responseJSON{
            response in
            
            
            let aIOData = response.data!
            let aIOJSON = response.result.value
            
            if response.result.isSuccess{
                //                    print(rRateJSON)
                do{
                    let lastIO = try JSONDecoder().decode(AttendanceLastInOutTimeRoot.self, from: aIOData)
                    
                    if let value = lastIO.inTime{
                        lastIn = value
                    }
                    if let value = lastIO.outTime{
                        lastOut = value
                    }
                    
                    print("from model \(lastIn, lastOut)")
                   completion(lastIn,lastOut)
                    
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
    


