//
//  SSTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SSTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   
   

}

extension SSTableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Items")
    }
}
