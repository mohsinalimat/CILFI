//
//  MeetingWithManagerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 22/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SVProgressHUD

class MeetingWithManagerViewController: TwitterPagerTabStripViewController {

    
    var childs = [UIViewController]()
    
    override func viewDidLoad() {
        
       
        
        settings.style.dotColor = UIColor.flatWhiteDark
        settings.style.selectedDotColor = UIColor.black
        settings.style.portraitTitleFont = UIFont.systemFont(ofSize: 18)
        settings.style.landscapeTitleFont = UIFont.systemFont(ofSize: 15)
        settings.style.titleColor = UIColor.black
        super.viewDidLoad()

        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .black
        // Do any additional setup after loading the view.
    }

   
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "makeARequest")
        let child2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "checkStatus")
        let child3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giveFeedback")
        let child4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mgrApproval")
        
        if ManagerInfo.isManager == "Yes"{
            childs.append(child1)
            childs.append(child2)
            childs.append(child3)
            childs.append(child4)
        }else{
            childs.append(child1)
            childs.append(child2)
            childs.append(child3)
        }
        
        return childs
    }
    
}
