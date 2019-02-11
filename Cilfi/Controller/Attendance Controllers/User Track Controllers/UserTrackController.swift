//
//  UserTrackController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 29/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import MapKit
import CoreLocation
import Alamofire

class UserTrackController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var flag = 0
    
    // API KEYS
    var userID = ""
    var dateTime = ""
    var tracktype = "m"
    
    var pin : CustomAnnotation!
    
    let locationManager = CLLocationManager()
    let userDataurl = "\(LoginDetails.hostedIP)/sales/teamdetail"
    let userTrackDataurl = "\(LoginDetails.hostedIP)/sales/usertrack"
    let user = UserTrackModel()
    
    var userlocation = [CLLocation]()
    let annotation2 = MKPointAnnotation()
    
    
    
    
    let date = Date()
    let dropDown = DropDown()
    
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var mapKitView2: MKMapView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    
     //MARK: - Current Location
    @IBAction func Users(_ sender: UIButton) {
        
        dropDown.dataSource = user.userDetails
        dropDown.anchorView = view
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
            self.userButton.setTitle(item, for: .normal)
            self.userIdLabel.text = self.user.empcode[index]
            self.userID = self.user.empcode[index]
            self.updateMap()
        }

    }
    
     //MARK: - dateButton
    @IBAction func dateButton(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.dateButton.setTitle(formatter.string(from: dt), for: .normal)
            
                self.dateTime = formatter.string(from: dt)
                self.updateMap()
            }
            }
        
        }
    
     //MARK: - GPS button on map
    @IBAction func gpsButton(_ sender: UIButton) {
        
        
        
        updateMap()
        getCurrentLocation()
        
    }
    
  //MARK: - viewdidload()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]
        
        user.getUsersData(url: userDataurl, header: headers)
        
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 1, y:120)
        dropDown.dismissMode = .onTap
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        
        mapKitView2.delegate = self
        mapKitView2.showsScale = true
        mapKitView2.showsPointsOfInterest = false
        mapKitView2.showsUserLocation = true
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
//        updateMap()
        
        
        
    }

  
}

extension UserTrackController{
    
    //MARK: - Current Location
    func getCurrentLocation(){
        let currentPositionAnnotation = MKPointAnnotation()
        if let location = locationManager.location?.coordinate{
            //Zoom to user location
            
            let noLocation = CLLocationCoordinate2D(latitude: (location.latitude), longitude: (location.longitude))
            let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            //            print(viewRegion)
            mapKitView2.setRegion(viewRegion, animated: true)
            
            currentPositionAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            currentPositionAnnotation.title = "Current Position"
            currentPositionAnnotation.subtitle = "Here you are"
            
            
            
            
            calculateDistance(lat: location.latitude, lng: location.longitude, currentAnnotation: currentPositionAnnotation)
        }else{
            print("unable to fetch location")
            
        }
        
        
    }
    
    //MARK: - Calculate Distance
    func calculateDistance(lat : Double , lng : Double, currentAnnotation : MKPointAnnotation){
      
        
        var finalPosition = CLLocation(latitude: lat, longitude: lng)
        var initialPosition : CLLocation?
        
        var annotations : [MKAnnotation] = [currentAnnotation]
//
//        print(userlocation.count)
//        print(userlocation)
        
        if userlocation.count != 0 {
            for x in 1...userlocation.count{
                if x != userlocation.count{
                let annotation = MKPointAnnotation()
                initialPosition = userlocation[x-1]
                let distanceInMeters = finalPosition.distance(from: initialPosition!)
                if distanceInMeters >= 50{
//                    print(initialPosition?.coordinate.latitude)
//                    print(initialPosition?.coordinate.longitude)
                    
                  
                    annotation.coordinate = initialPosition!.coordinate
                    
                    annotations.append(annotation)
                    }
                }
                else{
                    let lastannotation = MKPointAnnotation()
                    lastannotation.coordinate = (userlocation.last?.coordinate)!
                        lastannotation.title = "Last Location"
                        lastannotation.subtitle = "User was last seen here"
                        annotations.append(lastannotation)
                
               
                }
                
            }
//        print(annotations.count)
        mapKitView2.addAnnotations(annotations)
            }
    }
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//       let annotationView = MKPinAnnotationView(annotation: pin, reuseIdentifier: "lastlocation")
//        annotationView.image = UIImage(named: "placeholder")
////        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
////
////        annotationView.transform = transform
//        return annotationView
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserTrackTable"{
//           
            print("we are here")
        }
    }
        
    
    func updateMap(){
        
        if userID != "" && dateTime != ""{
            let allAnnotations = mapKitView2.annotations
            mapKitView2.removeAnnotations(allAnnotations)
            
            let headers : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : userID, "datetime" : dateTime, "tracktype" : tracktype ]

        getUserTrackData(url: userTrackDataurl, header: headers)
        }
        else{
            
            print("please select User & Date first.")
        }
        
    }
    
    
}
    



//MARK: - Networking
/***************************************************************/

extension UserTrackController{
    
    func getUserTrackData(url : String, header : [String:String]){
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
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
        
//      getCurrentLocation()
    }
    
   
}


