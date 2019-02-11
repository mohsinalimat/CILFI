//
//  LaunchScreenViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੦/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift


class LaunchScreenViewController: UIViewController {
    
    let realm = try! Realm()
 
    @IBOutlet weak var imgView: UIImageView!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = UIImage(named: "LaunchScreen-\(arc4random_uniform(2))")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goToPage), userInfo: nil, repeats: true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func goToPage(){
        
        timer.invalidate()
        
        let lastLoginDetails = realm.objects(LastLoginModel.self)
        
        
        if lastLoginDetails.isEmpty{
            
            performSegue(withIdentifier: "goToLoginScreen", sender: self)
            
        }else{
        
            if let loginDetails = lastLoginDetails.first{
                
                LoginDetails.companyCode = loginDetails.company!
                LoginDetails.hostedIP = loginDetails.hosted!
                LoginDetails.password = loginDetails.password!
                LoginDetails.username = loginDetails.username!
               
                getLoginDetails { (json) in
                    //   USER    INFO
                    defaults.set(LoginDetails.companyCode, forKey: "lastUsedCompanyID")
                    defaults.set(LoginDetails.companyCode, forKey: "company")
                    defaults.set(LoginDetails.username, forKey: "user")
                    defaults.set(LoginDetails.username, forKey: "employeeCode")
                    defaults.set(LoginDetails.password, forKey: "password")
                    
                    if !json.isEmpty{
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
                }
                
                performSegue(withIdentifier: "goToHomeVC", sender: self)
            }
            
           
           
            
        }
        
        
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func getLoginDetails(completion : @escaping (JSON)-> Void){
        DispatchQueue.main.async {
            Alamofire.request("\(LoginDetails.hostedIP)/sales/login", method: .get, headers : ["username" : LoginDetails.username , "password" : LoginDetails.password , "companycode" : LoginDetails.companyCode]).responseJSON{
                response in
                
                
                if let loginJSON : JSON = JSON(response.result.value){
                    
                    if response.result.isSuccess{
                        
                        completion(loginJSON)
                    }
                        
                    else{
                        print("Error: \(response.result.error!)")
                        completion(loginJSON)
                    }
                }
                else {
                    print("server under maintainance")
                }
            }
        }
    }
    
}
