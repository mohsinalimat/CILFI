//
//  CurrentAddress.swift
//  Cilfi
//
//  Created by Amandeep Singh on 27/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import SVProgressHUD

var currentAddress = ""
var currentPlace : GMSPlace?

func currentLocationAddress(){
    
    let placesClient = GMSPlacesClient()
    
    
    placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
        if let error = error {
            print("Pick Place error: \(error.localizedDescription)")
            return
        }
        
        if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList.likelihoods {
                let place = likelihood.place
                currentPlace = place
                currentAddress = place.formattedAddress!
                
            }
        }
    })
    
}


//MARK: - Get Address from final pos
/***************************************************************/

func getAddressfromLatLong(lat : Double, lng : Double, currentAdd:@escaping ( _ returnAddress :String)->Void){
    
//    print(lat, lng)
    // 1
    let geocoder = GMSGeocoder()
    
    // 2
    geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng)) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {return}
        
        
        currentAdd(lines.joined(separator: ","))

    
    
    }
    
    
    
}


func getAddressFromLatLong(lat : Double, lng : Double) -> String{
    let geocoder = GMSGeocoder()
    var lines = [String]()
    geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng)) { response, error in
        guard let address = response?.firstResult() else {return}
        
        lines = address.lines!
        
    }
    return lines.joined(separator: ",")
}
