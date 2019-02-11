//
//  NewLeadViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewLeadViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        currentLocationAddress()
        
        self.settings.style.selectedBarHeight = 1
        self.settings.style.selectedBarBackgroundColor = UIColor.flatBlack
        self.settings.style.buttonBarItemBackgroundColor = UIColor.init(hexString: "2AB0D9", withAlpha: 1.0)
        self.settings.style.buttonBarBackgroundColor = UIColor.init(hexString: "2AB0D9", withAlpha: 1.0)
        self.settings.style.selectedBarBackgroundColor = .white
        self.settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 12)
//        self.settings.style.selectedBarHeight = 4.0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarItemTitleColor = UIColor.flatBlackDark
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = 10
        self.settings.style.buttonBarRightContentInset = 10
        
        changeCurrentIndexProgressive = { (oldCell : ButtonBarViewCell? , newCell : ButtonBarViewCell?, progressPertange : CGFloat, changeCurrentIndex : Bool, animated : Bool) -> Void in
            
            guard changeCurrentIndex == true else{return}
            
            oldCell?.label.textColor =  UIColor.flatBlack
            newCell?.label.textColor = .white
            
            
        }
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lead")
        let child2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "company")
        let child3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "product")
        let child4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "upload")
        return [child1, child2, child3 , child4]
    }
    
    
}
