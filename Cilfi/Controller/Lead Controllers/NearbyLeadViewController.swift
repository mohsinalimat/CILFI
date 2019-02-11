//
//  NearbyLeadViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 09/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DropDown
import MapKit
import SVProgressHUD
import Alamofire

class NearbyLeadViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    let dropDown = DropDown()
    var mark = [GMSMarker]()
    
    var gmarker = ""
    
    
    
    let locationManager = CLLocationManager ()
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var distanceDropDown: UIButton!
    
    @IBOutlet weak var descLbl: UILabel!
    
    
    @IBAction func distanceDropDown(_ sender: UIButton) {
        
        dropDown.dataSource = ["5 KM Area", "10 KM Area", "15 KM Area", "20 KM Area", "25 KM Area", "30 KM Area", "35 KM Area", "40 KM Area", "45 KM Area", "50 KM Area & more"]
        dropDown.anchorView = distanceDropDown
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            switch index {
            case 0 : self.showPlacemarkers(distance: "5")
                break
            case 1 : self.showPlacemarkers(distance: "10")
                break
            case 2 : self.showPlacemarkers(distance: "15")
                break
            case 3 : self.showPlacemarkers(distance: "20")
                break
            case 4 : self.showPlacemarkers(distance: "25")
                break
            case 5 : self.showPlacemarkers(distance: "30")
                break
            case 6 : self.showPlacemarkers(distance: "35")
                break
            case 7 : self.showPlacemarkers(distance: "40")
                break
            case 8 : self.showPlacemarkers(distance: "45")
                break
            case 9 : self.showPlacemarkers(distance: "50")
                break
            default : SVProgressHUD.showError(withStatus: "Invalid Selection")
            }
        
            self.distanceDropDown.setTitle(item, for: .normal)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
       
        if let currentPos = locationManager.location?.coordinate{
            mapView.camera = GMSCameraPosition.camera(withLatitude: currentPos.latitude,
                                                      longitude: currentPos.longitude,
                                                      zoom: 12)
        }
//
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures   = true
        mapView.settings.tiltGestures   = true
        mapView.settings.rotateGestures = false
        mapView.settings.compassButton = false
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.addSubview(descLbl)
        
    }
    
    
    
    
    
    func showPlacemarkers(distance: String){
        
        mapView.clear()

        guard let latitude = (locationManager.location?.coordinate.latitude) else {return}
        guard let longitude = (locationManager.location?.coordinate.longitude) else {return}
        
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "lat" : String(latitude),"lng": String(longitude),"distance": distance ]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/NearbyLead", method: .get, headers : header).responseJSON{
            response in
            
            let nblData = response.data!
            let nblJSON = response.result.value
            if response.result.isSuccess{
//                                print(nblJSON)
                do{
                    let nbl = try JSONDecoder().decode(NearbyLeadRoot.self, from: nblData)
                   
                    
                    
                        for x in nbl.nbl{
                            let marker = GMSMarker()
                            
                            guard let lat = x.lat else{return}
                            guard let lng = x.lng else{return}
                            guard let address = x.address else{return}
                            guard let name = x.firmName else{return}
                            
                            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            marker.title = name
                            marker.snippet = address
                            marker.map = self.mapView
                            
                            
                            
                           
                            
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
    
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        gmarker = String(marker.position.latitude) + "," + String(marker.position.longitude)
        
        UIApplication.shared.openURL(URL(string: "comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")!)
    }
    
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    
        
        descLbl.isHidden = true
    }
    
    
}


