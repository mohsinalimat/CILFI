////
////  UpdateUserLocations.swift
////  Cilfi
////
////  Created by Amandeep Singh on 31/08/18.
////  Copyright © 2018 Focus Infosoft. All rights reserved.
////
//
//import Alamofire
//import CoreLocation
//import RealmSwift
//import SVProgressHUD
//import UIKit
//import SwiftyJSON
//
//
//
//var headers = [String:String]()
//
//
////class OfflineUserTracks : Object {
////
////    @objc dynamic var empCode = ""
////    @objc dynamic var checkDate = ""
////    @objc dynamic var lat = 0.0
////    @objc dynamic var lng = 0.0
////    @objc dynamic var battery = 0.0
////}
//
//
//
//class UpdateUserLocations{
//    
//    var offlineparameter = [Any]()
//    var timer : Timer?
//    var locationManager = CLLocationManager()
//    let realm = try! Realm()
//    
//    func startUpdation(){
//        
//        
//        
//        
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        
//        
//        
//            if !Connectivity.isConnectedToInternet(){
//                
//                let offLoginUserInfo = realm.objects(Login.self).filter("empCode == %@ AND company == %@ ", LoginDetails.username, LoginDetails.companyCode)
//                headers = ["username" : offLoginUserInfo.last?.user , "password" : offLoginUserInfo.last?.pass , "companycode" : offLoginUserInfo.last?.company, "yearmonth" : offLoginUserInfo.last?.yearMonth, "employeecode" : offLoginUserInfo.last?.empCode] as! [String : String]
//                
//                //   USER    INFO
//                defaults.set(LoginDetails.companyCode, forKey: "lastUsedCompanyID")
//                defaults.set(LoginDetails.companyCode, forKey: "company")
//                defaults.set(LoginDetails.username, forKey: "user")
//                defaults.set(LoginDetails.username, forKey: "employeeCode")
//                defaults.set(LoginDetails.password, forKey: "password")
//                
//                //  API
//                defaults.set(offLoginUserInfo.last?.trackTime, forKey: "trackTime")
//                defaults.set(offLoginUserInfo.last?.distance, forKey: "distance")
//                defaults.set(offLoginUserInfo.last?.email, forKey: "email")
//                defaults.set(offLoginUserInfo.last?.yearMonth, forKey: "yearMonth")
//                defaults.set(offLoginUserInfo.last?.latitude, forKey: "latitude")
//                defaults.set(offLoginUserInfo.last?.name, forKey: "name")
//                defaults.set(offLoginUserInfo.last?.longitude, forKey: "longitude")
//                defaults.set(offLoginUserInfo.last?.loginStatus, forKey: "loginStatus")
//                defaults.set(offLoginUserInfo.last?.imgUrl, forKey: "imgURL")
//                defaults.set(offLoginUserInfo.last?.designation, forKey: "designation")
//                defaults.set(offLoginUserInfo.last?.compURL, forKey: "compUrl")
//                
//                defaults.set(offLoginUserInfo.last?.routeDistance, forKey: "routeDistance")
//                defaults.set(offLoginUserInfo.last?.stayTime, forKey: "stayTime")
//                defaults.set(offLoginUserInfo.last?.trackingStatus, forKey: "trackingStatus")
//                defaults.set(offLoginUserInfo.last?.ghostSelfie, forKey: "ghostSelfie")
//                
//                
//            }else{
//                headers = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!]
//        }
//            
//        
//        
//        if CLLocationManager.locationServicesEnabled(){
//            self.locationManager.startUpdatingLocation()
//            self.locationManager.allowsBackgroundLocationUpdates = true
//            
//            
//        }
//
//        if defaults.string(forKey: "trackingStatus")! == "ON"{
//            Timer.scheduledTimer(timeInterval: Double(defaults.string(forKey: "trackTime")!)!*60 , target: self, selector: #selector(self.checkConnectivity), userInfo: nil, repeats: true)
//        }
//
//        print(Double(defaults.string(forKey: "trackTime")!)!*60)
//    }
//    
//
//    
//    @objc func checkConnectivity(){
//        print(LoginDetails.username)
//        
//        DispatchQueue.main.async {
////            print(Date())
//           
//            currentLocationAddress()
//            print("checkconnec")
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//            
//            self.locationManager = CLLocationManager()
//            
//            let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
//            
//            
//            if components.hour! >= 9 && components.hour! < 21{
//                
//                print("checkconn54")
//                
//                if !Connectivity.isConnectedToInternet(){
//                    print("checkconn11")
//                    self.saveOfflineData()
//                }else{
//                    
//                    guard let coordinates = self.locationManager.location?.coordinate else {return}
//                    
////
//                    var offUserInfo = self.realm.objects(OfflineUserTracks.self).filter("empCode == %@", LoginDetails.username)
//                    
//                    if offUserInfo.count != 0{
//                        if self.offlineparameter.count == 0{
//                            print("checkconn1")
//                            for x in offUserInfo{
//                                
//                                self.fetchOfflineParamsAndAddress(lat: x.lat, lng: x.lng, batterypercent: x.battery, checkDate: x.checkDate, empCode: x.empCode) { (params) in
//                                    
//                                    self.offlineparameter.append(params)
//                                }
//                                
//                            }
//                            
//                        }else{
//                            print("checkconn2")
//                            currentLocationAddress()
//                            self.setOfflineParams()
//
//                        }
//                    }
//                    
//                   
//                    
//                    
//                    self.setParameters(para: ["Address":currentAddress,"BatteryStatus":Int(UIDevice.current.batteryLevel * 100),"checkDate":formatter.string(from: Date()),"CheckType":"M","EmpCode":LoginDetails.username,"EmpName":defaults.string(forKey: "name")!,"GeoFencing":"","Imei":"","Lat":String(coordinates.latitude),"Lng":String(coordinates.longitude),"LocationMode":"Network","MacAddress":"","SimNumber":"","TrackMode":"Online"])
//                }
//            }
//        }
//    }
//    
//    func saveOfflineData(){
//        DispatchQueue.main.async {
//            print("saveOfflineData")
//            
//            if !Connectivity.isConnectedToInternet(){
//                
//                
//                if let coordinates = self.locationManager.location?.coordinate{
//                    
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//                    
//                    let loginUserTracks = OfflineUserTracks()
//                    
//                    loginUserTracks.empCode = LoginDetails.username
//                    loginUserTracks.checkDate = formatter.string(from: Date())
//                    loginUserTracks.lat = coordinates.latitude
//                    loginUserTracks.lng = coordinates.longitude
//                    loginUserTracks.battery = Double(UIDevice.current.batteryLevel * 100)
//                    
//                    
//                    
//                    try! self.realm.write {
//                        
//                        self.realm.add(loginUserTracks)
//                        
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func fetchOfflineParamsAndAddress(lat: Double , lng: Double, batterypercent: Double, checkDate : String, empCode: String,parameter : @escaping (_ param:[String:Any]) -> Void){
//        
//        DispatchQueue.main.async {
//            print("fetchOfflineParamsAndAddress")
//            let geocoder = CLGeocoder()
//            
//            geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lng), completionHandler: { (placemark, error) in
//                
//                guard let address = placemark?.first else {return}
//                //                            print(offUserInfo[x].lat, offUserInfo[x].lng)
//                var addressString : String = ""
//                
//                if address.name != nil {
//                    addressString = addressString + address.name! + ", "
//                }
//                if address.subLocality != nil {
//                    addressString = addressString + address.subLocality! + ", "
//                }
//                if address.thoroughfare != nil {
//                    addressString = addressString + address.thoroughfare! + ", "
//                }
//                if address.locality != nil {
//                    addressString = addressString + address.locality! + ", "
//                }
//                if address.country != nil {
//                    addressString = addressString + address.country! + ", "
//                }
//                if address.postalCode != nil {
//                    addressString = addressString + address.postalCode! + " "
//                }
//                
//                
//                //                            print(addressString)
//                
//                parameter(["Address":addressString,"BatteryStatus":Int(batterypercent),"checkDate":checkDate,"CheckType":"M","EmpCode":empCode,"EmpName":"","GeoFencing":"","Imei":"","Lat":String(lat),"Lng":String(lng),"LocationMode":"GPS","MacAddress":"","SimNumber":"","TrackMode":"Offline"])
//                
//            })
//            
//            
//            
//        }
//        
//        
//    }
//    
//    
//    func setParameters(para: [String:Any]){
//        
//        DispatchQueue.main.async {
//            print("setParams")
//            print("online \(para.count)")
//            print(para)
//            Alamofire.request("\(LoginDetails.hostedIP)/sales/UserTracking" , method : .post,  parameters : ["userTracks":[para]], encoding: JSONEncoding.default , headers: headers).responseJSON{
//                response in
//                
//                let loginJSON : JSON = JSON(response.result.value)
//                
//                if response.result.isSuccess{
////                    print("Success! Posting the User Track data")
//                    
////                    print(loginJSON)
//                    
//                }else{
//                    //print("Error: \(response.result.error!)")
//                    //                    print(loginJSON)
//                }
//                
//            }
//            
//        }
//    }
//    
//    func setOfflineParams(){
//        DispatchQueue.main.async {
//            print("setoffparams")
//            let params = ["userTracks":self.offlineparameter]
//            print("offline \(self.offlineparameter.count)")
//            print(params)
//            
//            Alamofire.request("\(LoginDetails.hostedIP)/sales/UserTracking" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
//                response in
//                
//                let loginJSON : JSON = JSON(response.result.value)
//                
//                if response.result.isSuccess{
////                    print(loginJSON)
//                    if loginJSON["returnType"].string == "Tracking Data Updated Successfully"{
//                        self.offlineparameter = [Any]()
//                        let offUserInfo = self.realm.objects(OfflineUserTracks.self).filter("empCode == %@", LoginDetails.username)
//                        try? self.realm.write {
//                            self.realm.delete(offUserInfo)
//                            
//                        }
//                        
//                    }
//                    
//                    
//                    
//                }else{
//                    
//                }
//                
//                
//            }
//        }
//        
//    }
//    
//    
//    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
//        
//    }
//    
//}
//
//
//
