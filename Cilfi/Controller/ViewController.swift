//
//  ViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 14/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import DropDown
import RealmSwift
import CoreLocation

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

var defaults = UserDefaults.standard


//MARK:- View Controller
class ViewController: UIViewController, CLLocationManagerDelegate {
    let realm = try! Realm()
    let loginArray = [Login]()
    let login = Login()
    
    //variables for company dropdown
    var code = [String]()
    var hostIP = [String]()
    var codename = [String]()
    /////////////////////////////////
    
    let locationManager = CLLocationManager()
    
    var company = ""
//    var pass = ""
    
    
//    var flag = 1
    
    var tempurl = ""
    
    
    @IBOutlet weak var switchcontroller: UISwitch!
    
    @IBOutlet weak var passtf: UITextField!
    @IBOutlet weak var usertf: UITextField!
//    @IBOutlet weak var comptf: UITextField!
    
    
    var companyIdArray = [String]()
    
    
    //MARK:- Dropdown
    
    @IBOutlet weak var companyIDDropDown: UIButton!
    
    @IBAction func companyIDDropDown(_ sender: UIButton) {
       
        code = [String]()
        hostIP = [String]()
        codename = [String]()
        
        let offHIPdata = self.realm.objects(HostedIP.self)
        if offHIPdata.count != 0{
            for x in offHIPdata{
                if companyIdArray.contains(x.code){
                    code.append(x.code)
                    codename.append("\(x.fullName)(\(x.code))")
                    hostIP.append(x.hostedIP)
                }
            }
            
        }
        
       
        let dropDown = DropDown()
        
        dropDown.dataSource = codename
        dropDown.anchorView = companyIDDropDown
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            
            self.company = self.code[index]
            self.companyIDDropDown.titleLabel?.text = self.code[index]
            LoginDetails.hostedIP = self.hostIP[index]
        
            print(self.hostIP[index])
        }
        
    }
    
    
   
        
    
    
    //MARK:- add company button
    
    @IBOutlet weak var addCompanyButton: UIBarButtonItem!
    @IBAction func addCompanyButton(_ sender: UIBarButtonItem) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Company", message: "Enter a new company code", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Company Code"
        }
        
       
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            guard let x = textField?.text else{return}
            
            if x == "" || x == nil{
                
                // create the alert
                let alert = UIAlertController(title: "Empty", message: "Company code can't be empty.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
                
            else{
                let offHIPdata = self.realm.objects(HostedIP.self)
                if Connectivity.isConnectedToInternet(){
                    Alamofire.request("http://80.241.216.95:81/sales/gethostedip", method: .get, headers: ["companycode":x]).responseJSON{
                    response in
                    
                    let hostedData = response.data!
                    
                    
                        
                    if response.result.isSuccess{
                        do{
                            var flag = true
                            let hostedIP = try JSONDecoder().decode(HostedIPRoot.self, from: hostedData)
                            let hosted = HostedIP()
                            guard let fullName = hostedIP.fullName else {return}
                            guard let shortName = hostedIP.shortName else {return}
                            guard let hostedip = hostedIP.hostedIP else {return}
                            
                            if !fullName.isEmpty && !shortName.isEmpty && !hostedip.isEmpty{
                               
                               LoginDetails.hostedIP = hostedip
                                
                                if offHIPdata.count != 0{
                                    
                                    for data in offHIPdata{
                                        
                                        
                                        if data.code.contains(x) && data.hostedIP.contains(hostedip){
                                            
                                           flag = false
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            if flag == true {
                               
                                    hosted.code = x
                                    hosted.hostedIP = hostedip
                                
                                    hosted.fullName = fullName
                                    hosted.shortName = shortName
                                
                                    try! self.realm.write {
                                        self.realm.add(hosted)
                                        self.company = x
                                        self.companyIDDropDown.titleLabel?.text = x
                                }
                            }else{
                                self.company = x
                                self.companyIDDropDown.titleLabel?.text = x
                                
                            }
                                
                            
                        }catch{
                            
                        }
                    }
                    
                }
                
                }else{
                    SVProgressHUD.showError(withStatus: "You need an internet connection to verify the company code")
                }
            }
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        navigationItem.hidesBackButton = true
        
       locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        if let companyId = defaults.array(forKey: "Company-ID") as? [String]{
            companyIdArray = companyId
        }
        
        self.hideKeyboardWhenTappedAround()
        
        //Adding Image To TF
        let emailImage = UIImage(named: "profile-icon")
        addLeftImageTo(txtField: usertf, andImage: emailImage!)
        
        let passwordImage = UIImage(named: "lock-icon")
        addLeftImageTo(txtField: passtf, andImage: passwordImage!)
        
        
        // MARK:-  Listen for keyBoard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -50
        }
        else{
            view.frame.origin.y = 0
        }
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        if let lastcompanyId = defaults.string(forKey: "lastUsedCompanyID"){
            company = lastcompanyId
            companyIDDropDown.titleLabel?.text = lastcompanyId
            print(lastcompanyId)
            let offHIPdata = self.realm.objects(HostedIP.self)
            
            if !offHIPdata.isEmpty{
                for x in offHIPdata{
                    if x.code == lastcompanyId{
                        LoginDetails.hostedIP = x.hostedIP
                    }
                }
            }
            
            companyIDDropDown.setTitle(lastcompanyId, for: .normal)
        }
        
        let offHIPdata = self.realm.objects(HostedIP.self)
        if offHIPdata.count == 0{
            companyIDDropDown.isHidden = false
            addCompanyButton.tintColor = .black
            navigationItem.rightBarButtonItem = addCompanyButton
        }else if offHIPdata.count == 1{
            companyIDDropDown.isHidden = false
            navigationItem.rightBarButtonItem = addCompanyButton
        }else{
            companyIDDropDown.isHidden = false
            navigationItem.rightBarButtonItem = addCompanyButton
        }
    }
    
    
    
    //MARK:- Login
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
//        print(LoginDetails.hostedIP)
        
        try! realm.write {
            realm.delete(realm.objects(LastLoginModel.self))
        }
        
        
        if company != "" && passtf.text != "" && usertf.text != ""{
            let parameters : [String:String] = ["username" : usertf.text! , "password" : passtf.text! , "companycode" : company, "fcmtoken" : InstanceID.instanceID().token()!]
            
//            print(parameters)
            if Connectivity.isConnectedToInternet() {
                //                print("Yes! internet is available.")
                SVProgressHUD.show(withStatus: "Loging In..")
               
                getLoginData(url : tempurl, parameter : parameters)
            }else{
                offlineLogin()
            }
        }
    }
    
    
    
    //MARK:- Adding Image To TF Method
    
    func addLeftImageTo(txtField : UITextField, andImage img : UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
        
    }
    
    
    
    
    //MARK:- Offline Login
    
    func offlineLogin(){
        let offUserInfo = realm.objects(Login.self)
        
        if offUserInfo.count == 0 {
            let alert = UIAlertController(title: "Bad Connection", message: "Seems like you need an Internet Connection for loging in.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            for x in 1...offUserInfo.count{
                if offUserInfo[x-1].company == company && offUserInfo[x-1].pass == passtf.text && offUserInfo[x-1].user == usertf.text{
                    SVProgressHUD.showSuccess(withStatus: "Successfully logged in.")
                    LoginDetails.companyCode = offUserInfo[x-1].company
                    LoginDetails.username = offUserInfo[x-1].user
                    LoginDetails.password = offUserInfo[x-1].pass
                    performSegue(withIdentifier: "goToHomeScreen", sender: self)
                    
                }
                else{
                                   SVProgressHUD.showError(withStatus: "Wrong ID/Password")
                }
            }
        }
    }
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getLoginData(url : String, parameter : [String:String]){
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/login", method: .get, headers : parameter).responseJSON{
            response in
            
            
            if let loginJSON : JSON = JSON(response.result.value){
                
                if response.result.isSuccess{
                    
                    //                print("Success! Got the Login data")
//                print(loginJSON)
                    self.updateLoginData(json : loginJSON)
                }
                    
                else{
                    print("Error: \(response.result.error!)")
                                   print(loginJSON)
                }
            }
            else {
                print("server under maintainance")
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateLoginData(json:JSON){
        
        let loginSessionDetails = LastLoginModel()
        
        if let loginstat = json["LoginStatus"].string{
            print(json)
            if loginstat == "Login Successfully"{
                
                
                
                LoginDetails.companyCode = company
                LoginDetails.username = usertf.text!
                LoginDetails.password = passtf.text!
                
                
                if switchcontroller.isOn{
                    loginSessionDetails.company = company
                    loginSessionDetails.username = usertf.text!
                    loginSessionDetails.password = passtf.text!
                    loginSessionDetails.hosted = LoginDetails.hostedIP
                    
                    try! realm.write{
                        realm.add(loginSessionDetails)
                    }
                   
                }
                
                setDefaults(json: json)
                setRealmData(json: json)
                performSegue(withIdentifier: "goToHomeScreen", sender: self)
                SVProgressHUD.showSuccess(withStatus: json["LoginStatus"].string)
                addCompany()
                
                
            }
                
            else{
                SVProgressHUD.showError(withStatus: json["LoginStatus"].string)
                print("Error.....Unable to Fetch Data")
                
            }
        }else if let loginstat = json["Message"].string{
            SVProgressHUD.showError(withStatus: loginstat)
            passtf.text = ""
            usertf.text = ""
        }
    }
    
    
    //MARK: - Set Realm Data
    /***************************************************************/
    func setRealmData(json : JSON){
        var flag = true
        let userInfo = realm.objects(Login.self)
        
        if userInfo.count != 0{
            for x in 1...userInfo.count{
                if userInfo[x-1].company == company && userInfo[x-1].pass == passtf.text && userInfo[x-1].user == usertf.text && userInfo[x-1].yearMonth == json["YearMonth"].stringValue{
                    flag = false
                }
            }
        }
        
        if flag{
            
            
            
            login.company = company
            login.pass = passtf.text!
            login.user = usertf.text!
            login.yearMonth = json["YearMonth"].stringValue
            login.empCode = usertf.text!
            
            login.trackTime = json["TrackTime"].stringValue
            login.distance = json["Distance"].stringValue
            login.email = json["Email"].stringValue
            login.latitude = json["Latitude"].stringValue
            login.name = json["Name"].stringValue
            login.longitude = json["Longitude"].stringValue
            login.loginStatus = json["LoginStatus"].stringValue
            login.imgUrl = json["ImageUrl"].stringValue
            login.designation = json["Designation"].stringValue
            login.compURL = json["CompUrl"].stringValue
            login.routeDistance = json["RouteDistance"].stringValue
            login.stayTime = json["StayTime"].stringValue
            login.trackingStatus = json["TrackingStatus"].stringValue
            login.ghostSelfie = json["GhostSelfi"].stringValue
            
            
                try! realm.write {
                    realm.add(login)
                }
            
        }
        
//        print(userInfo)
    }
    
    
    //MARK: - Setting Defaults
    /***************************************************************/
    func setDefaults(json : JSON){
        
//        print(json)
        
//        print(company, user, pass)
        
        //   USER    INFO
        defaults.set(company, forKey: "lastUsedCompanyID")
        defaults.set(LoginDetails.companyCode, forKey: "company")
        defaults.set(LoginDetails.username, forKey: "user")
        defaults.set(LoginDetails.username, forKey: "employeeCode")
        defaults.set(LoginDetails.password, forKey: "password")
        
        
        //  API
        defaults.set(json["TrackTime"].stringValue, forKey: "trackTime")
        defaults.set(json["Distance"].stringValue, forKey: "distance")
        defaults.set(json["Email"].stringValue, forKey: "email")
        defaults.set(json["YearMonth"].stringValue, forKey: "yearMonth")
        defaults.set(json["Latitude"].stringValue, forKey: "latitude")
        defaults.set(json["Name"].stringValue, forKey: "name")
        defaults.set(json["Longitude"].stringValue, forKey: "longitude")
        defaults.set(json["LoginStatus"].stringValue, forKey: "loginStatus")
        defaults.set(json["ImageUrl"].stringValue, forKey: "imgURL")
        defaults.set(json["Designation"].stringValue, forKey: "designation")
        defaults.set(json["CompUrl"].stringValue, forKey: "compUrl")
        defaults.set(json["RouteDistance"].stringValue, forKey: "routeDistance")
        defaults.set(json["StayTime"].stringValue, forKey: "stayTime")
        defaults.set(json["TrackingStatus"].stringValue, forKey: "trackingStatus")
        defaults.set(json["GhostSelfi"].stringValue, forKey: "ghostSelfie")
        
        
    }

    
    func addCompany(){
        if !companyIdArray.contains(LoginDetails.companyCode){
            companyIdArray.append(company)
            defaults.set(companyIdArray, forKey: "Company-ID")
        }
    }
    
    
}

extension Realm {
    func writeAsync<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let config = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(wrappedObj)
                    
                    try realm.write {
                        block(realm, obj)
                    }
                }
                catch {
                    errorHandler(error)
                }
            }
        }
    }
}
