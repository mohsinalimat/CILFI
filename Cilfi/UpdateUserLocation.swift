//
//  UpdateUserLocation.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import MapKit
import CoreLocation
import RealmSwift
import SVProgressHUD
import Alamofire
import SwiftyJSON

var headers = [String:String]()



class UpdateUserLocation{

    
    var timer : Timer?

    var realm = try! Realm()

    func startUpdation(){

        UIDevice.current.isBatteryMonitoringEnabled = true



        if !Connectivity.isConnectedToInternet(){

            let offLoginUserInfo = realm.objects(Login.self).filter("empCode == %@ AND company == %@ ", LoginDetails.username, LoginDetails.companyCode)
            headers = ["username" : offLoginUserInfo.last?.user , "password" : offLoginUserInfo.last?.pass , "companycode" : offLoginUserInfo.last?.company, "yearmonth" : offLoginUserInfo.last?.yearMonth, "employeecode" : offLoginUserInfo.last?.empCode] as! [String : String]

            //   USER    INFO
            defaults.set(LoginDetails.companyCode, forKey: "lastUsedCompanyID")
            defaults.set(LoginDetails.companyCode, forKey: "company")
            defaults.set(LoginDetails.username, forKey: "user")
            defaults.set(LoginDetails.username, forKey: "employeeCode")
            defaults.set(LoginDetails.password, forKey: "password")

            //  API
            defaults.set(offLoginUserInfo.last?.trackTime, forKey: "trackTime")
            defaults.set(offLoginUserInfo.last?.distance, forKey: "distance")
            defaults.set(offLoginUserInfo.last?.email, forKey: "email")
            defaults.set(offLoginUserInfo.last?.yearMonth, forKey: "yearMonth")
            defaults.set(offLoginUserInfo.last?.latitude, forKey: "latitude")
            defaults.set(offLoginUserInfo.last?.name, forKey: "name")
            defaults.set(offLoginUserInfo.last?.longitude, forKey: "longitude")
            defaults.set(offLoginUserInfo.last?.loginStatus, forKey: "loginStatus")
            defaults.set(offLoginUserInfo.last?.imgUrl, forKey: "imgURL")
            defaults.set(offLoginUserInfo.last?.designation, forKey: "designation")
            defaults.set(offLoginUserInfo.last?.compURL, forKey: "compUrl")

            defaults.set(offLoginUserInfo.last?.routeDistance, forKey: "routeDistance")
            defaults.set(offLoginUserInfo.last?.stayTime, forKey: "stayTime")
            defaults.set(offLoginUserInfo.last?.trackingStatus, forKey: "trackingStatus")
            defaults.set(offLoginUserInfo.last?.ghostSelfie, forKey: "ghostSelfie")


        }else{
            headers = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!]
        }

//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
//            SVProgressHUD.showInfo(withStatus: "Cilfi needs 'Always Allow' location access to fetch your location.")
//        case .authorizedAlways:
//            CLLocationManager().startUpdatingLocation()
//            CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
//            CLLocationManager().allowsBackgroundLocationUpdates = true
//            CLLocationManager().pausesLocationUpdatesAutomatically = false
//        }

//        startTimer()
    }



    


    

    
}
