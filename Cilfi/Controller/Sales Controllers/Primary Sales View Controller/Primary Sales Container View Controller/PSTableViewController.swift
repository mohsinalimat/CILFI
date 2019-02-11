//
//  PSTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 19/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class PSTableViewController: UIViewController {

    @IBOutlet var totalQtyLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    static var quant : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    
        
        // Do any additional setup after loading the view.
    }
    
    
    func updateValues(){
     
        
        totalQtyLbl.text = PSTableViewController.quant
     }
    
    
    

   
}

extension PSTableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Items")
    }
}
