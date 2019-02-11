//
//  HomeViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 15/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SwiftyJSON
import SVProgressHUD
import CoreLocation
import RealmSwift


class OfflineUserTracks : Object {
    
    @objc dynamic var empCode = ""
    @objc dynamic var checkDate = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
    @objc dynamic var battery = 0.0
}


struct bgParams{
    var empCode : String?
    var checkDate : String?
    var lat : Double?
    var lng : Double?
    var battery : Double?
}


var realm = try! Realm()

//userTrackVariable
var timeintervalFromDate = Date()


@available(iOS 10.0, *)
class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var offUserInfo = realm.objects(OfflineUserTracks.self).filter("empCode == %@", LoginDetails.username)
    
    var offlineparameter = [Any]()
    
    
    
    var locationManager = CLLocationManager()
    let updateUserLocation = UpdateUserLocation()
    
    static var reload  = Bool()
    var offlineHeaderSetFlag = true
    var tempurl = "\(LoginDetails.hostedIP)/sales/getmenu"
    
    let menu = MenuModel()
    
    var menuVC : MenuTableViewController!
    
    var bgParameters = [bgParams]()
    
    @IBAction func dashBoardBtn(_ sender: UIButton) {
         navigateToView(view: "Dashboard")
    }
    
    @IBAction func directoryBtn(_ sender: UIButton) {
         SVProgressHUD.showInfo(withStatus: "This feature will be available soon.")
    }
    
    @IBAction func paySlipBtn(_ sender: UIButton) {
         navigateToView(view: "PaySlip")
    }
    
    @IBAction func leaveRequestBtn(_ sender: UIButton) {
         navigateToView(view: "LeaveRequest")
    }
    
    @IBAction func attendanceReportBtn(_ sender: UIButton) {
        
        navigateToView(view: "AttendanceReport")
        
    }
    
    @IBAction func reimbursementClaimBtn(_ sender: UIButton) {
         navigateToView(view: "ReimbursmentClaim")
    }
    
    @IBAction func helpDeskBtn(_ sender: UIButton) {
        SVProgressHUD.showInfo(withStatus: "This feature will be available soon.")
    }
    
    @IBAction func markAttendanceBtn(_ sender: UIButton) {
       
        navigateToView(view: "MarkAttendance")
        
    }
    
    func navigateToView(view : String){
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: view)
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        
        updateUserLocation.startUpdation()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            SVProgressHUD.showInfo(withStatus: "Cilfi needs Always Location Access to send UserTrack data.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("")
        }
        
        super.viewDidLoad()
        addGestures()
        
        
        let mark = MarkAttendenceModel()
        mark.fetchOfflineAddress()
        
        menu.getMenuData(url: self.tempurl, parameter: headers)
        
        let ledger = LedgerAccountModel()
        ledger.getCustomerNameData()
        
        let manager = ManagerModel()
        manager.getManagerDetails()
        
        menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
        
        // location  manager delegate
        //------------------------------------------------------------------------------------
        if((locationManager) != nil)
        {
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.delegate = nil
            
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        //        locationManager.distanceFilter = 2
        //        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        //------------------------------------------------------------------------------------
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        menu.getMenuData(url: self.tempurl, parameter: headers)
        //         menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
        
        let refreshrightButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.refreshrightButtonTapped))
        let logoutButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "main-menu-logout"), style:.plain, target: self, action: #selector(self.logoutRightButtonTapped))
        let leftButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "main-menu-icon"), style:.plain, target: self, action: #selector(self.leftButtonTapped))
        refreshrightButtonItem.tintColor = UIColor.black
        leftButtonItem.tintColor = UIColor.black
        logoutButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItems = [leftButtonItem]
        navigationItem.rightBarButtonItems = [ logoutButtonItem ,refreshrightButtonItem]
        
        closeWhileReloading()
        
        //         menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        currentLocationAddress()
        
        
        
    }
    
    
    
    func addGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.responseToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.responseToGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func responseToGesture(gesture : UISwipeGestureRecognizer){
        switch gesture.direction{
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
            
        case UISwipeGestureRecognizer.Direction.left:
            closeOnSwipe()
        default:
            break
        }
    }
    
    @objc func leftButtonTapped(){
        
        if AppDelegate.menuBool{
            //show the menu
            showMenu()
        }else{
            //close the menu
            closeMenu()
        }
        
    }
    
    @objc func refreshrightButtonTapped(){
        
        if Connectivity.isConnectedToInternet(){
            
            menu.getMenuData(url: self.tempurl, parameter: headers)
            //            print(tempurl)
            //            print(headers)
            
            if !AppDelegate.menuBool{
                SVProgressHUD.show()
                closeWhileReloading()
                menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
            }else{
                SVProgressHUD.show()
                
                menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "No internet access.")
        }
    }
    
    @objc func logoutRightButtonTapped(){
        
        try! realm.write {
            realm.delete(realm.objects(LastLoginModel.self))
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    func closeOnSwipe(){
        if AppDelegate.menuBool{
            //show the menu
            //showMenu()
        }else{
            //close the menu
            closeMenu()
        }
    }
    
    func closeWhileReloading(){
        if AppDelegate.menuBool{
            //show the menu
            //showMenu()
        }else{
            //close the menu
            closeMenuWhileReloading()
        }
    }
    
    
    func showMenu(){
        
        let logoutButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "main-menu-logout"), style:.plain, target: self, action: #selector(self.logoutRightButtonTapped))
        logoutButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [logoutButtonItem]
        
        UIView.animate(withDuration: 0.4) { ()->Void in
            
            self.menuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-60)
            self.menuVC.view.backgroundColor = UIColor(white: 1, alpha: 0)
            self.addChild(self.menuVC)
            self.view.addSubview(self.menuVC.view)
            AppDelegate.menuBool = false
        }
        
    }
    
    
    func closeMenu(){
        let logoutButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "main-menu-logout"), style:.plain, target: self, action: #selector(self.logoutRightButtonTapped))
        logoutButtonItem.tintColor = UIColor.black
        let rightButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.refreshrightButtonTapped))
        rightButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [logoutButtonItem, rightButtonItem]
        
        UIView.animate(withDuration: 0.4, animations: { ()->Void in
            self.menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 60)
        }) { (finished) in
            
            self.menuVC.view.removeFromSuperview()
            
        }
        
        AppDelegate.menuBool = true
    }
    
    func closeMenuWhileReloading(){
        let logoutButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "main-menu-logout"), style:.plain, target: self, action: #selector(self.logoutRightButtonTapped))
        logoutButtonItem.tintColor = UIColor.black
        let rightButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.refreshrightButtonTapped))
        rightButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [logoutButtonItem, rightButtonItem]
        
        UIView.animate(withDuration: 0, animations: { ()->Void in
            self.menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 60)
        }) { (finished) in
            
            self.menuVC.view.removeFromSuperview()
            
        }
        
        
        
        AppDelegate.menuBool = true
    }
    
}







@available(iOS 10.0, *)
extension HomeViewController{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if -timeintervalFromDate.timeIntervalSinceNow >= Double(defaults.string(forKey: "trackTime")!)! * 60{
            
            print(-timeintervalFromDate.timeIntervalSinceNow)
            print("tracktime = - - - 0 0 - - -\(Double(defaults.string(forKey: "trackTime")!)! * 60)")
            
            timeintervalFromDate = Date()
            currentLocationAddress()
            if defaults.string(forKey: "trackingStatus")! == "ON"{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                
                let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
                
                
                if components.hour! >= 9 && components.hour! < 21{
                    
                    if !Connectivity.isConnectedToInternet(){
                        
                        
                        saveOfflineData()
                        
                        
                        
                    }else{
                        
                        guard let coordinates = locationManager.location?.coordinate else {return}
                        let state = UIApplication.shared.applicationState
                        if state == .active {
                            //                             foreground
                            let offlineUserInfo = realm.objects(OfflineUserTracks.self).filter("empCode == %@", LoginDetails.username)
                            if offlineUserInfo.count != 0{
                                if offlineparameter.count == 0{
                                    
                                    for x in offUserInfo{
                                        
                                        fetchOfflineParamsAndAddress(lat: x.lat, lng: x.lng, batterypercent: x.battery, checkDate: x.checkDate, empCode: x.empCode) { (params) in
                                            
                                            self.offlineparameter.append(params)
                                        }
                                        
                                    }
                                    
                                }else{
                                    
                                    currentLocationAddress()
                                    self.setOfflineParams()
                                    
                                }
                                
                                
                            }
                        }
                        
                        self.setParameters(para: ["Address":currentAddress,"BatteryStatus":Int(UIDevice.current.batteryLevel * 100),"checkDate":formatter.string(from: Date()),"CheckType":"M","EmpCode":LoginDetails.username,"EmpName":defaults.string(forKey: "name")!,"GeoFencing":"","Imei":"","Lat":String(coordinates.latitude),"Lng":String(coordinates.longitude),"LocationMode":"Network","MacAddress":"","SimNumber":"","TrackMode":"Online"])
                        
                    }
                    
                    
                    
                }
                
            }
        }
        
    }
    
    
    
    func saveOfflineData(){
        
        print("saveOfflineData")
        
        
        if let coordinates = locationManager.location?.coordinate{
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
            
            let loginUserTracks = OfflineUserTracks()
            
            loginUserTracks.empCode = LoginDetails.username
            loginUserTracks.checkDate = formatter.string(from: Date())
            loginUserTracks.lat = coordinates.latitude
            loginUserTracks.lng = coordinates.longitude
            loginUserTracks.battery = Double(UIDevice.current.batteryLevel * 100)
            
            
            
            DispatchQueue(label: "background").async {
                autoreleasepool {
                    let realm = try! Realm()
                    
                    try! realm.write {
                        realm.add(loginUserTracks)
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    func setOfflineParams(){
        
        var offlineUserInfo = realm.objects(OfflineUserTracks.self).filter("empCode == %@", LoginDetails.username)
        
        
        print("setoffparams")
        let params = ["userTracks":self.offlineparameter]
        
        print("offline \(self.offlineparameter.count)")
        print(params)
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/UserTracking" , method : .post,  parameters : params, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                //                    print(loginJSON)
                if loginJSON["returnType"].string == "Tracking Data Updated Successfully"{
                    self.offlineparameter = [Any]()
                    
                    try! realm.write {
                        realm.delete(offlineUserInfo)
                        
                    }
                    
                }
                
                
                
            }else{
                
            }
            
            
        }
    }
    
    
    
    func fetchOfflineParamsAndAddress(lat: Double , lng: Double, batterypercent: Double, checkDate : String, empCode: String,parameter : @escaping (_ param:[String:Any]) -> Void){
        
        print("fetchOfflineParamsAndAddress")
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lng), completionHandler: { (placemark, error) in
            
            guard let address = placemark?.first else {return}
            //                            print(offUserInfo[x].lat, offUserInfo[x].lng)
            var addressString : String = ""
            
            if address.name != nil {
                addressString = addressString + address.name! + ", "
            }
            if address.subLocality != nil {
                addressString = addressString + address.subLocality! + ", "
            }
            if address.thoroughfare != nil {
                addressString = addressString + address.thoroughfare! + ", "
            }
            if address.locality != nil {
                addressString = addressString + address.locality! + ", "
            }
            if address.country != nil {
                addressString = addressString + address.country! + ", "
            }
            if address.postalCode != nil {
                addressString = addressString + address.postalCode! + " "
            }
            
            
            //                            print(addressString)
            
            parameter(["Address":addressString,"BatteryStatus":Int(batterypercent),"checkDate":checkDate,"CheckType":"M","EmpCode":empCode,"EmpName":"","GeoFencing":"","Imei":"","Lat":String(lat),"Lng":String(lng),"LocationMode":"GPS","MacAddress":"","SimNumber":"","TrackMode":"Offline"])
            
        })
    }
    
    
    
    
    func setParameters(para: [String:Any]){
        
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/UserTracking" , method : .post,  parameters : ["userTracks":[para]], encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the User Track data")
                
                print(loginJSON)
                
            }else{
                //print("Error: \(response.result.error!)")
                //                    print(loginJSON)
            }
            
        }
        
        
    }    
}



