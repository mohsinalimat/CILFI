//
//  MarkAttendanceController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SVProgressHUD
import RealmSwift
import GooglePlaces
import UserNotifications


var reg = "O"
//MARK: - Time&Date Methods
/***************************************************************/
@available(iOS 10.0, *)
class MarkAttendanceController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    
    var timer = Timer()
    //get the notification center
    let center = UNUserNotificationCenter.current()
    
    
    let geoCoder = CLGeocoder()
    var postalCode = ""
    var city = ""
    var state = ""
    
    var imgType = ""
    var inghostImg = ""
    var outghostImg = ""
    
    var ghostImg = ""
    
    static var bgFetch = true
    let fence = GeoFenceModel()
    let mark = MarkAttendenceModel()
    var fenceDistance = false
    
    let locationManager = CLLocationManager()
    
    let tempurl = "\(LoginDetails.hostedIP)/sales/markattendance"
    let fenceurl = "\(LoginDetails.hostedIP)/sales/fencinglatlng"
    
    
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inTimeLabel: UILabel!
    @IBOutlet weak var outTimeLabel: UILabel!
    
    override func viewDidLoad() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        UIDevice.current.isBatteryMonitoringEnabled = true
        fence.getFenceData()
        
        super.viewDidLoad()
        
        currentLocationAddress()
        
        
        //        SVProgressHUD.show()
        mapKitView.delegate = self
        mapKitView.showsScale = true
        mapKitView.showsPointsOfInterest = false
        mapKitView.showsUserLocation = true
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            SVProgressHUD.showInfo(withStatus: "Cilfi needs location access to mark attendace ")
        case .authorizedAlways, .authorizedWhenInUse:
            let viewRegion = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(viewRegion, animated: false)
        }
        
        
        displayInOut()
        
        
        addressLabel.text = currentAddress
        
//        if currentAddress == ""{
//            SVProgressHUD.showError(withStatus: "Unable to fetch address.")
//
//        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        
        
       
        
        if let currentPlace = currentPlace?.addressComponents{
            
            for x in currentPlace{
                if x.type == "locality"{
                    state = x.name
                }
                if x.type == "sublocality_level_1"{
                    city = x.name
                }
                if x.type == "postal_code"{
                    postalCode = x.name
                }
                
            }
            
            backgroungFetch()
            
        }
        
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
//        UIDevice.current.isBatteryMonitoringEnabled = false
//        print(timer.isValid)
        persistOfflineAttendance()
        timer.invalidate()
//        print(timer.isValid)
    }
    
    @IBAction func inTimeButtonPressed(_ sender: UIButton) {
        
        
        mark.inOut = "I"
        let today : String!
        today = mark.getTodayString()
//        inTimeLabel.text = today
        ghostImg = inghostImg
        
        if Connectivity.isConnectedToInternet(){
            loginData()
        }
        else{
            offlineAttnd()
            SVProgressHUD.showInfo(withStatus: "Saved as offline data. This will go live once you get back online.")
            inTimeLabel.text = dateTimeLabel.text
        }
        
    }
    
    
    @IBAction func outTimeButtonPressed(_ sender: UIButton) {
        
        mark.inOut = "O"
        let today : String!
        today = mark.getTodayString()
//        outTimeLabel.text = today
        
//        print(Connectivity.isConnectedToInternet())
        
        ghostImg = outghostImg
        
        if Connectivity.isConnectedToInternet(){
            loginData()
        }
        else{
            offlineAttnd()
            
            SVProgressHUD.showInfo(withStatus: "Saved as offline data. This will go live once you get back online.")
            outTimeLabel.text = dateTimeLabel.text
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        picker.dismiss(animated: true)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            let imageData : NSData = image.jpeg(.lowest)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            if imgType == "I"{
                inghostImg = strBase64
                inImageBtn.tintColor = UIColor.flatGray
                
            }else if imgType == "O"{
                 outghostImg = strBase64
                 outImgBtn.tintColor = UIColor.flatGray
            }
        
        }

    }
    
    @objc func tick() {
        dateTimeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
    }
    
    
    @IBAction func gpsButtonPressed(_ sender: Any) {
        if let location = locationManager.location?.coordinate{
            //Zoom to user location
            
            let noLocation = CLLocationCoordinate2D(latitude: (location.latitude), longitude: (location.longitude))
            let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 100, longitudinalMeters: 100)
            //            print(viewRegion)
            mapKitView.setRegion(viewRegion, animated: true)
        }else{
            print("unable to fetch location")
            
        }
    }
    
    @IBOutlet weak var inImageBtn: UIButton!
    @IBAction func inImgBtn(_ sender: UIButton) {
        imgType = "I"
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    @IBOutlet weak var outImgBtn: UIButton!
    @IBAction func outImgBtn(_ sender: UIButton) {
        imgType = "O"
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
        outImgBtn.tintColor = UIColor.flatGray
    }
    func displayInOut(){
        
        mark.getLastAttendanceInOut { (lIN, lOUT) in
           
            
            
           
                let formatter = DateFormatter()
                formatter.timeZone = Calendar.current.timeZone
                formatter.locale = Calendar.current.locale
                
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let lastIn = formatter.date(from: lIN){
                    if lastIn == formatter.date(from: "1900-01-01T00:00:00"){
                        self.inTimeLabel.text = ""
                    }else{formatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
                        self.inTimeLabel.text = formatter.string(from: lastIn)
                        
                    }
                    
                }
                
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let lastOut = formatter.date(from: lOUT){
                    if lastOut == formatter.date(from: "1900-01-01T00:00:00"){
                        self.outTimeLabel.text = ""
                    }else{
                    formatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
                    self.outTimeLabel.text = formatter.string(from:lastOut)
                }
            }
        }
        
    }
    
    
    func backgroungFetch(){
        DispatchQueue.main.async {
            if MarkAttendanceController.bgFetch{
                self.backgroungFetch()
            }else{
                if self.fence.allow == "Y"{
                    self.setUpGeofenceLocation()
                    reg = "O"
                }else if self.fence.allow == "N"{
                    reg = "I"
                }
                MarkAttendanceController.bgFetch = true
                
            }
            
        }
        
    }
    
    
    //MARK: - set Up geoFence
    func setUpGeofenceLocation() {
        
        //        SVProgressHUD.show()
        
        guard let location = locationManager.location?.coordinate else {return}
        
        var geofence = [CLCircularRegion]()
        
        annotations = [MKPointAnnotation]()
        if fence.lat.count != 0{
            
            for x in 1...fence.lat.count{
                
                mapKitView.removeAnnotations(annotations)
                let distance = Double(fence.distance[x-1])
                let identifier = fence.fenceCode[x-1]
                
                
                
                let geofenceRegionCenter = CLLocationCoordinate2DMake(fence.lat[x-1], fence.lng[x-1])
                let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: distance, identifier: identifier);
                
                geofenceRegion.notifyOnExit = true;
                geofenceRegion.notifyOnEntry = true;
                locationManager.startMonitoring(for: geofenceRegion)
                
                //                var circle = MKCircle(center: CLLocationCoordinate2D(latitude: fence.lat[x-1], longitude: fence.lng[x-1]), radius: distance as CLLocationDistance)
                //                mapKitView.add(circle)
                
                //        add pins
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: fence.lat[x-1], longitude: fence.lng[x-1])
                annotation.title = defaults.string(forKey: "company")
                annotation.subtitle = "Fence Code : \(fence.fenceCode[x-1])"
                annotations.append(annotation)
                
                
                //                //   Location Check of user
                //                if let location = locationManager.location?.coordinate{
                //
                //                    let distanceInMeters = CLLocation(latitude: fence.lat[x-1], longitude: fence.lng[x-1]).distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
                //
                //                    print("Distance in meters\(distanceInMeters)")
                //                    print("Distance\(distance)")
                //                    if distanceInMeters <= distance {
                //                        fenceDistance = true
                //                    }
                //
                //
                //                }
            }
            
            mapKitView.addAnnotations(annotations)
            SVProgressHUD.dismiss()
        }else{
            SVProgressHUD.dismiss()
        }
        
        
    }
    
    
    func loginData(){
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel * 100
        guard let coordinates = locationManager.location?.coordinate else {return}
        
        
        
        updateLocation()
        
        SVProgressHUD.show()
        
        
        let parameters : [String:[Any]] = [ "markAttnList" :[["Address" : currentAddress, "AttenMode": "Online","CheckDate":mark.checkDate,"CheckTime":mark.checkTime,"CheckType":"M","City":city,"EmpCode":defaults.string(forKey: "employeeCode")!,"GmailID":defaults.string(forKey: "email")!,"Imei":"","InOut":mark.inOut,"Lat":coordinates.latitude,"Lng":coordinates.longitude,"MacAddress":"","Pin":postalCode,"SimNumber":"","State":state,"YearMonth":defaults.string(forKey: "yearMonth")!, "Attachment":"", "BatteryStatus":batteryLevel, "GhostImage":ghostImg, "LocationMode": "GPS"]]]
        
        print(parameters)
        
        //Check whether within geofence region
        if reg == "I" || fenceDistance == true{
            
            setAttendanceData(url: tempurl, header: headers, parameter: parameters)
            
        }
        else if reg == "O" || fenceDistance == false{
            SVProgressHUD.showError(withStatus: "Unable to mark attendace \nYou need to be within range of the GeoFence to mark the attendance.")
            inTimeLabel.text = ""
            outTimeLabel.text = ""
        }
        
        
        
    }
    
    
    func offlineAttnd(){
        do{
            
            
            let attendance = MarkAttendance()
            UIDevice.current.isBatteryMonitoringEnabled = true
            
            let coordinates = locationManager.location?.coordinate
            
            UIDevice.current.isBatteryMonitoringEnabled = true
            let batteryLevel = UIDevice.current.batteryLevel * 100
            
            
            attendance.user = LoginDetails.username
            attendance.company = LoginDetails.companyCode
            attendance.attenMode = "Offline"
            attendance.checkDate = mark.checkDate
            attendance.checkTime = ("\(mark.checkDate) \(mark.checkTime)")
            attendance.checkType = "M"
            attendance.ghostImg = ghostImg
            attendance.inOut = mark.inOut
            attendance.lat = coordinates?.latitude ?? 0
            attendance.lng = coordinates?.longitude ?? 0
            attendance.batteryStatus = Int(batteryLevel)
            attendance.locMode = "No Network"
            
            
            
            try realm.write {
                
                realm.add(attendance)
                ghostImg = ""
                inghostImg = ""
                outghostImg = ""
            }
            
            
            
        }catch{
            print(error)
        }
    }
    //MARK: - Networking
    /***************************************************************/
    
    //Write the setAttendanceData method here:
    
    func setAttendanceData(url : String, header : [String:String], parameter : [String:[Any]]){
        
        
//        print(parameter)
        Alamofire.request(url , method : .post,  parameters : parameter, encoding: JSONEncoding.default , headers: header).responseJSON{
            response in
            
            //                        print(response)
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                if loginJSON["returnType"].string == "Attendance mark successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    UIDevice.current.isBatteryMonitoringEnabled = false
                    self.displayInOut()
                    self.ghostImg = ""
                    self.inImageBtn.tintColor = UIColor.blue
                    self.inghostImg = ""
                    self.outghostImg = ""
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
    
    func fetchOfflineAttendanceData(parameters : @escaping (([Any])-> Void)){
        var offlineParam = [Any]()
        
        
        let attnd = self.realm.objects(MarkAttendance.self).filter("user == %@ AND company == %@", LoginDetails.username,LoginDetails.companyCode)
        
//        print("attttttttttttttttttt\(attnd)")
        
        if attnd.count != 0 {
                for x in 1...attnd.count{
                    
                    let pin = MarkAttendenceModel.pin[x-1]
                    let city = MarkAttendenceModel.city[x-1]
                    let state = MarkAttendenceModel.state[x-1]
                    let address = MarkAttendenceModel.address[x-1]
                    let attendanceMode = attnd[x-1].attenMode
                    let cd = attnd[x-1].checkDate
                    let ct = attnd[x-1].checkTime
                    let checkType = attnd[x-1].checkType
                    let empCode = attnd[x-1].user
                    let comp = attnd[x-1].company
                    let lat = attnd[x-1].lat
                    let lng = attnd[x-1].lng
                    let img = attnd[x-1].ghostImg
                    let batteryLevel = UIDevice.current.batteryLevel * 100
                    let locMode = attnd[x-1].locMode
                    let inOut = attnd[x-1].inOut
                    
                    
                    
                    let param : [String:Any] = ["Address" : address, "AttenMode": attendanceMode,"CheckDate":cd,"CheckTime":ct,"CheckType":"M","City":city,"EmpCode":empCode,"GmailID":defaults.string(forKey: "email")!,"Imei":"","InOut":inOut,"Lat":String(lat),"Lng":String(lng),"MacAddress":"","Pin":pin,"SimNumber":"","State":state,"YearMonth":defaults.string(forKey: "yearMonth")!, "Attachment":"", "BatteryStatus":batteryLevel, "GhostImage":img, "LocationMode": locMode]
                    
                    
                    
                    if self.fence.lat.count != 0 {
                        for x in 1...self.fence.lat.count{
                            
                            let distance = Double(self.fence.distance[x-1])
                            //                            print(self.fence.lat[x-1])
                            //                            print(self.fence.lng[x-1])
                            let distanceInMeters = CLLocation(latitude: self.fence.lat[x-1], longitude: self.fence.lng[x-1]).distance(from: CLLocation(latitude: lat, longitude: lng))
                                                        print(distanceInMeters)
                                                        print("\(lat),\(lng)")
                                                        print(distance)
                            if distanceInMeters < distance {
                                
                                offlineParam.append(param)
                            }
                            
                        }
                        
                    }else{
                        offlineParam.append(param)
                    }
                    
                   
                }
                
             parameters(offlineParam)
                
            
            
        }
        
        
        
    }
    
    
    func persistOfflineAttendance(){
        
        if Connectivity.isConnectedToInternet(){
            
            
                self.fetchOfflineAttendanceData(parameters: {(params) in
                    print(params)
                    self.mark.setOfflineAttendanceData(url: self.tempurl, header: headers, parameter: [ "markAttnList" : params] )
                })
                
            
            
            
        }
    }
    
    
    
    
}



@available(iOS 10.0, *)
extension MarkAttendanceController{
    
    func updateLocation(){
        
        
        if let currentPlace = currentPlace?.addressComponents{
            
            for x in currentPlace{
                if x.type == "locality"{
                    state = x.name
                }
                if x.type == "sublocality_level_1"{
                    city = x.name
                }
                if x.type == "postal_code"{
                    postalCode = x.name
                }
                
            }
            //            print(fenceDistance)
            addressLabel.text = currentAddress
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        fenceDistance = false
        if fence.lat.count != 0{
            
            currentLocationAddress()
            
            for x in 1...fence.lat.count{
                
                let distance = Double(fence.distance[x-1])
                
                //   Location Check of user
                if let location = locationManager.location?.coordinate{
                    
                    let distanceInMeters = CLLocation(latitude: fence.lat[x-1], longitude: fence.lng[x-1]).distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
                    
                    //                    print("Distance in meters \(distanceInMeters)")
                    //                    print("Distance \(distance)")
                    if distanceInMeters < distance {
                        fenceDistance = true
                        
                    }
                    
                    
                }
                
            }
            updateLocation()
            
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        currentLocationAddress()
        reg = "I"
        print("Welcome to FocusInfosoft! If the waves are good, you can try surfing!")
        
        presentNotification(title: "Welcome!", sub: "GeoFence Active", body: "You entered the geofence area. To mark your attendance open CILFI now.")
        
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        currentLocationAddress()
        reg = "O"
        fenceDistance = false
        print("Bye! Hope you had a great day at the Focus!")
        presentNotification(title: "Bye!", sub: "GeoFence In-Active", body: "You left the geofence area. To mark your attendance open CILFI now.")
    }
}

@available(iOS 10.0, *)
extension MarkAttendanceController{
    
    func presentNotification(title: String, sub: String, body : String){
        
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "\(sub), \(body)"
        content.sound = UNNotificationSound.default
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5.0, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        
        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
            
        }
        
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
        }
        
        
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
