//
//  UserTrackModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 29/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class UserTrackModel: UIViewController, CLLocationManagerDelegate {
    
    
    var userDetails = [String]()
    var empcode = [String]()
    var userlocation = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    //MARK: - Networking
    /***************************************************************/
    
    //Write the getUsersData for dropdown method here:
    
    func getUsersData(url : String, header : [String:String]) -> [String]{
        
        
        print(header)
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            
            let userDetailData = response.data!
            let userDetailJSON = response.result.value
            if response.result.isSuccess{
//                                print("UserJSON: \(userDetailJSON)")
                do{
                    let fence = try JSONDecoder().decode(TeamDetailRoot.self, from: userDetailData)
                   
                    for x in fence.teamdetail{
                        self.userDetails.append(x.empName!)
                        self.empcode.append(x.empCode!)
                    }
//                    print(self.userDetails)
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
       return userDetails
    }
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getTrackData for dropdown method here:
    
    func getUserTrackData(date : String, employee: String, locations :@escaping ( ([CLLocation], [Date], [String], [Double]) -> Void)){
        
        var userlocation = [CLLocation]()
        var locationDate = [Date]()
        var notificationSent = [String]()
        var trackedKms = [Double]()
        
        let header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "employeecode" : employee, "datetime" : date]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/UserTrack", method: .get, headers : header).responseJSON{
            response in
            
            let userTrackDetailData = response.data!
            let userTrackDetailJSON = response.result.value
            
            if response.result.isSuccess{
//                                print("UserTrackJSON: \(userTrackDetailJSON)")
                do{
                    let track = try JSONDecoder().decode(UserTrackRoot.self, from: userTrackDetailData)
                    
                    for x in track.userTrack{
                        if let y = x.lat{
                            if let z = x.lng{
                                let latitude = Double(y)
                                let longitude = Double(z)
                                userlocation.append(CLLocation(latitude: latitude!, longitude: longitude!))
                                
                            }
                        }else{
                            print("Unable to fetch Latitude Longitude")
                        }
                        
                        
                        
                        if let value = x._checkDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            
                            locationDate.append(formatter.date(from: value)!)
                        }
                        
                        if let value = x.notificationSent{
                            notificationSent.append(value)
                        }
                        
                        if let value = x.meters{
                            trackedKms.append(Double(value))
                        }
                        
                    }
                    
                    locations(userlocation, locationDate, notificationSent, trackedKms)
                    
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
