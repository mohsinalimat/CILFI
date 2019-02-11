//
//  TrackAllViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import SVProgressHUD

class TrackAllViewController: UIViewController, GMSMapViewDelegate {
    
    var empName  = [String]()
    var checkDate  = [String]()
    var latitude  = [String]()
    var longitude  = [String]()
    var address  = [String]()
    var batterySatus  = [Int]()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        mapView.delegate = self
        
        getTrackAllData()
        
        
        // map Settings
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures   = true
        mapView.settings.tiltGestures   = true
        mapView.settings.rotateGestures = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.addSubview(menuBtn)
    }
    
    
    func getTrackAllData(){
        
        empName  = [String]()
        checkDate  = [String]()
        latitude  = [String]()
        longitude  = [String]()
        address  = [String]()
        batterySatus  = [Int]()
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/trackall", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let trackAllData = response.data!
            let trackAllJSON = response.result.value
            
            if response.result.isSuccess{
                                print("UserJSON: \(trackAllJSON)")
                do{
                    let trackAll = try JSONDecoder().decode(TrackAllRoot.self, from: trackAllData)
                    let dateFormatter = DateFormatter()
                    
                    for x in trackAll.taData{
                        
                        if let name = x.empName{
                            self.empName.append(name)
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
                        
                        if let address = x.address{
                            self.address.append(address)
                        }
                        
                        if let battery = x.batterySatus{
                            self.batterySatus.append(battery)
                        }
                        
                    }
                    self.updateMap()
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
    
    func updateMap(){
        
       let sysDateTime = Date()
       
        
        mapView.clear()
        SVProgressHUD.dismiss()
        
        if latitude.isEmpty{
            SVProgressHUD.showError(withStatus: "No Values Found.")
            
        }else{
            let dateFormatter = DateFormatter()
            
            for x in 1...latitude.count{
                
                guard let lat = Double(latitude[x-1]) else {return}
                guard let lng = Double(longitude[x-1]) else {return}
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                guard let fulldate = dateFormatter.date(from: checkDate[x-1]) else{return}
                dateFormatter.dateFormat = "dd-MMMM-yyyy"
                let date = dateFormatter.string(from: fulldate)
            
                dateFormatter.dateFormat = "HH:mm:ss"
                let time = dateFormatter.string(from: fulldate)
                
                let marker = GMSMarker()
                
                if abs(fulldate.timeIntervalSinceNow) < 86400 {
                    if abs(fulldate.timeIntervalSinceNow) <= 1800{
                        marker.icon = GMSMarker.markerImage(with: UIColor.flatGreen)
                        marker.title = "\(empName[x-1]) (Online)"
                    }else{
                        marker.icon = GMSMarker.markerImage(with: UIColor.flatRedDark)
                        marker.title = "\(empName[x-1]) (Offline)"
                    }
                }else{
                    marker.icon = GMSMarker.markerImage(with: UIColor.flatGray)
                    marker.title = "\(empName[x-1]) (Inactive)"
                }
        
                
                
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                marker.snippet = "\(date) \(time)  \(batterySatus[x-1]) \n\(address[x-1])"
                marker.map = mapView
                
                let location = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 17.0)
                mapView.animate(to: location)
            }
            
        }
        
        
        
        
    }
    
    
    
}
