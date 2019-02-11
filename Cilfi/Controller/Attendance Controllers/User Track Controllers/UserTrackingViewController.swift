//
//  UserTrackingViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 20/09/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SVProgressHUD
import SwiftyJSON
import DropDown
import DatePickerDialog

class UserTrackingViewController: UIViewController {
    
    let team = TeamDetailModel()
    let user = UserTrackModel()
    let dropDown = DropDown()
    var userlocation = [CLLocation]()
    let locationManager = CLLocationManager()
    let location = CLLocation()
    let polyline = GMSPolyline()
    
    
    // API KEYS
    var userID = ""
    var dateTime = ""
    var tracktype = "m"
    var username = ""
    
    let userDataurl = "\(LoginDetails.hostedIP)/sales/teamdetail"
    let userTrackDataurl = "\(LoginDetails.hostedIP)/sales/usertrack"
    
    @IBAction func tableBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToUserTrackTable", sender: self)
    }
    
    @IBOutlet weak var selectUserBtn: UIButton!
    @IBAction func selectUserBtn(_ sender: UIButton) {
        
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = selectUserBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectUserBtn.setTitle("\(item) \(self.team.employeeCode[index])", for: .normal)
            self.userID = self.team.employeeCode[index]
            self.username = item
            self.getMapData()
            //            self.circle()
            
            
        }
        
    }
    
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBAction func selectDateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMMM-yyyy"
                self.selectDateBtn.setTitle(formatter.string(from: dt), for: .normal)
                formatter.dateFormat = "yyyy-MM-dd"
                self.dateTime = formatter.string(from: dt)
                self.getMapData()
                
            }
        }
        
        
    }
    
    @IBOutlet weak var gmsMap: GMSMapView!
    @IBOutlet weak var tableBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team.getTeamData()
        
        
        
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
      
        dropDown.dismissMode = .onTap
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.flatWhite
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        
        //        showMarker(position: camera.target)
        
        gmsMap.settings.scrollGestures = true
        gmsMap.settings.zoomGestures   = true
        gmsMap.settings.tiltGestures   = true
        gmsMap.settings.rotateGestures = true
        gmsMap.settings.compassButton = true
        gmsMap.settings.myLocationButton = true
        gmsMap.isMyLocationEnabled = true
        
        
        GMSServices.provideAPIKey("AIzaSyCTbL7NYpuCSvnyhLy6l3af6J5SW3vXpBA")
            GMSPlacesClient.provideAPIKey("AIzaSyCTbL7NYpuCSvnyhLy6l3af6J5SW3vXpBA")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserTrackTable"{
            let vc = segue.destination as! UserTrackTableViewController
            vc.date = dateTime
            vc.userid = userID
            vc.username = username
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gmsMap.addSubview(tableBtn)
    }
    
    func getMapData(){
        
        print(dateTime, userID)
        user.getUserTrackData(date: dateTime, employee: userID ) { (loc, date, notification, trackedKms) in
            
            
            
            if !loc.isEmpty{
                
                var initialPos = loc[0]
                var initialDate = date[0]
                
                self.gmsMap.clear()
                
                for x in 1..<loc.count{
                    
                    self.directions(source: loc[x-1], destination: loc[x])
                    
                    if x == 1{
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: loc[x-1].coordinate.latitude, longitude: loc[x-1].coordinate.longitude)
                        marker.title = "Initial Position"
                        marker.icon = GMSMarker.markerImage(with: UIColor.flatGreen)
                        marker.map = self.gmsMap
                        
                        let camera = GMSCameraPosition.camera(withLatitude: loc[x-1].coordinate.latitude, longitude: loc[x-1].coordinate.longitude, zoom: 15.0)
                        self.gmsMap.camera = camera
                        
                    }else if x == loc.count-1{
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: loc[x].coordinate.latitude, longitude: loc[x].coordinate.longitude)
                        marker.title = "Final Position"
                        marker.icon = GMSMarker.markerImage(with: UIColor.flatRed)
                        marker.map = self.gmsMap
                        
                        
                    }
                    
                    
                    if notification[x-1] == "Y"{

                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: loc[x].coordinate.latitude, longitude: loc[x].coordinate.longitude)
                        marker.title = "Pit-stop \(x-1)"
                        marker.icon = GMSMarker.markerImage(with: UIColor.flatPowderBlue)
                        marker.map = self.gmsMap
                    }
                    
                    
                }
                
            }
        }
    }
    
    
    func directions(source : CLLocation, destination : CLLocation){
        
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.coordinate.latitude),\(source.coordinate.longitude)&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&sensor=false&key=AIzaSyCTbL7NYpuCSvnyhLy6l3af6J5SW3vXpBA"
        
                print(urlString)
        
        Alamofire.request(urlString).responseJSON { response in
            
            //            print(response.result.value)
            
            do{
                
                let json : JSON = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes{
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.flatBlue
                    polyline.map = self.gmsMap
                }
            }catch{
                
            }
        }
    }
}
