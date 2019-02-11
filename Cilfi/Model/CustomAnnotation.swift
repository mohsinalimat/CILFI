//
//  CustomAnnotation.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import MapKit

class CustomAnnotation : NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D
    
    init(title : String , subtitle : String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    
}
