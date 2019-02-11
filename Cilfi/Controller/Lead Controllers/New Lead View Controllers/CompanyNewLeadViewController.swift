//
//  CompanyNewLeadViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GooglePlaces

class CompanyNewLeadViewController: UIViewController {

     let placesClient = GMSPlacesClient()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        

    
    }

    
}

    extension CompanyNewLeadViewController : IndicatorInfoProvider{
        func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "Company")
        }
        
    }

