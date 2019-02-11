//
//  GoogleMapsViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 02/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DatePickerDialog
import DropDown
import Alamofire
import SwiftyJSON


class GoogleMapsViewController: UIViewController {

    
    
    let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]
    
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
    
    let userDataurl = "\(LoginDetails.hostedIP)/sales/teamdetail"
    let userTrackDataurl = "\(LoginDetails.hostedIP)/sales/usertrack"
    
     
    @IBOutlet weak var switchToTableBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBAction func dateButton(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.dateButton.setTitle(formatter.string(from: dt), for: .normal)
                
                self.dateTime = formatter.string(from: dt)
                self.updateMap()
//                self.circle()
            }
        }
    
    }
    
    @IBAction func userButton(_ sender: UIButton) {
    
        dropDown.dataSource = user.userDetails
        dropDown.anchorView = userButton
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.userButton.setTitle(item, for: .normal)
            self.userIdLabel.text = self.user.empcode[index]
            self.userID = self.user.empcode[index]
            self.updateMap()
//            self.circle()
        }
    
    }
   
    
    
    //MARK: - View did Load
    /***************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.mapView.addSubview(switchToTableBtn)
        
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:120)
        dropDown.dismissMode = .onTap
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.flatWhite
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
   

//        showMarker(position: camera.target)
        
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures   = true
        mapView.settings.tiltGestures   = true
        mapView.settings.rotateGestures = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
//       mapView.animate(toZoom: 2)
        
        user.getUsersData(url: userDataurl, header: headers)
        circle()
        
        
        
    }
    

    
    //MARK: - updateMAp()
    /***************************************************************/
    func updateMap(){
        
        
         let userTrackHeaders : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "datetime" : dateTime, "employeecode" : defaults.string(forKey: "user")!]
        
        if userID != "" && dateTime != ""{
            mapView.clear()
            getUserTrackData(url: userTrackDataurl, header: userTrackHeaders)
        }
        else{
            
            print("please select User & Date first.")
        }
        
    }
    
    
    //MARK: - getUserTrackData
    /***************************************************************/
    func getUserTrackData(url : String, header : [String:String]){
        
       
        userlocation = [CLLocation]()
        
        
        //      print("we are here")
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let userTrackDetailData = response.data!
            let userTrackDetailJSON = response.result.value
            if response.result.isSuccess{
                
               print("UserTrackJSON: \(userTrackDetailJSON)")
                do{
                    let track = try JSONDecoder().decode(UserTrackRoot.self, from: userTrackDetailData)
                    
                    for x in track.userTrack{
                        if let y = x.lat{
                            if let z = x.lng{
                                let latitude = Double(y)
                                let longitude = Double(z)
                                self.userlocation.append(CLLocation(latitude: latitude!, longitude: longitude!))
                               
                            }
                            
                        }
                            
                        else{
                            print("Unable to fetch Latitude Longitude")
                        }
                        
                        
                    }
                
                    self.showMarker()
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
    
    
    
    //MARK: - Show marker
    /***************************************************************/
    func showMarker(){
        if userlocation.isEmpty{
            let alert = UIAlertController(title: "No Values", message: "User Location not found for the specific date!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Invalid date", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
//            print(userlocation.count)
            
            let marker = GMSMarker()
            let marker2 = GMSMarker()
            let final = userlocation.first
            let initial = userlocation.last
            var finalPos = userlocation.last
            var initialPos = userlocation.first
            
            //map initial position marker
            marker.position = CLLocationCoordinate2D(latitude: initial!.coordinate.latitude, longitude: initial!.coordinate.longitude)
            marker.title = "Initial Position"
            marker.icon=UIImage(named: "custom-placemarker-user")
            marker.map = mapView
            
            // map final postion marker
            marker2.position = CLLocationCoordinate2D(latitude: final!.coordinate.latitude, longitude: final!.coordinate.longitude)
            marker2.title = "Final Position"
            marker2.icon=UIImage(named: "custom-placemarker-user")
            marker2.map = mapView
            
            for x in 1...userlocation.count{
                
                if x != userlocation.count{
                    let marker3 = GMSMarker()
                    initialPos = userlocation[x-1]
                    finalPos = userlocation[x]
                    
                    let distanceInMeters = initialPos!.distance(from: finalPos!)
                    if distanceInMeters >= 100{
                
                   
                    marker3.position = CLLocationCoordinate2D(latitude: initialPos!.coordinate.latitude, longitude: initialPos!.coordinate.longitude)
                    marker3.title = "User Locations"
                    marker3.icon=UIImage(named: "custom-placemarker-user")
                    marker3.map = mapView
                    
            
                    }
                    
                }
            }
            directions(source: initial!, destination: final!)
            circle()
        }
        
    }
  
    //MARK: - directions
    /***************************************************************/
    func directions(source : CLLocation, destination : CLLocation){
    
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.coordinate.latitude),\(source.coordinate.longitude)&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&sensor=false"

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
                    polyline.map = self.mapView
                }
            }catch{
                
            }
        }
        
        
        
        
        
        
        
    }
    
    //MARK: - circle
    /***************************************************************/
    func circle(){
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.6986, longitude: 77.1151)
        marker.title = "Focus Infosoft pvt. ltd."
        marker.icon=UIImage(named: "custom-placemarker-office")
        marker.map = mapView
        
        let circleCenter = CLLocationCoordinate2D(latitude: 28.6986, longitude: 77.1151)
        let circ = GMSCircle(position: circleCenter, radius: 100)
        
        circ.map = mapView
    }
   
        


    }


//MARK: - zoom in to user location
/***************************************************************/
extension GoogleMapsViewController{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        updateLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
    }
    
    
    func updateLocation(latitude : Double, longitude : Double){
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        mapView.camera = camera
    }
}

