//
//  LeadNewLeadViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GooglePlaces

class LeadNewLeadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationAddress()
        
    }

  
    
}

extension LeadNewLeadViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Lead")
    }
    
}
