//
//  UploadNewLeadViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import SVProgressHUD

class UploadNewLeadViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func btn(_ sender: UIButton) {
      
        let leadDataURL = "\(LoginDetails.hostedIP)/Sales/LeadData"
        if Upload.visitinCard != ""{
            
        
        let parameters : [String: Any] = ["Code": defaults.string(forKey: "employeeCode")!, "CommitSales": Product.salesCommitedMonthly, "Country": Lead.country, "CreatedByCode": defaults.string(forKey: "employeeCode")!,"ExecutiveName": defaults.string(forKey: "name")!, "FirmAddress": Lead.address, "FirmAge": Company.yearsInBusiness, "FirmArea": Company.shopArea, "FirmCity": Lead.city, "FirmContactPerson":Lead.contactPersonName , "FirmContactPersonDesg": Lead.designation, "FirmContactPersonEmail": Lead.contactPersonEmailID, "FirmContactPersonMobile": Lead.mobileNo, "FirmGstn": Company.gstin, "FirmName": Lead.ddFirm, "FirmPan": Company.pan, "FirmPropType": Company.shopOwnership, "FirmState": Lead.state, "FirmType": Company.fType, "FirmWeb":Lead.website, "GodownArea":Company.godownArea, "GodownPropType":Company.godownOwnerShip, "Lat": Lead.lat , "Lng": Lead.lng, "NextDate": "\(Lead.nextFollowUpDate) \(Lead.nextFollowUpTime)", "OtherDistributor": Product.otherDealership, "PinCode": Lead.pincode, "Product": Product.interestedProducts , "ProductDealsIn": Product.products, "ReffSource":Lead.srName, "ReffSourceTitle": Lead.srInfo, "Software": Product.billingSoft, "Status": Lead.leadStatus, "TradeRef1FirmName": Product.firmname1, "TradeRef1MobileNo": Product.mobileno1, "TradeRef1PersonName": Product.personname1, "TradeRef2FirmName": Product.firmname2, "TradeRef2MobileNo": Product.mobileno2, "TradeRef2PersonName": Product.personname2, "TradeRef3FirmName": Product.firmname3, "TradeRef3MobileNo": Product.mobileno3, "TradeRef3PersonName": Product.personname3, "TurnOver1": Company.annualTurnover1, "TurnOver2": Company.annualTurnover2, "TurnOver3": Company.annualTurnover3, "VisitDate": Lead.visitDate,  "VisitingCardImage":Upload.visitinCard,  "FrontOfShopImage": Upload.frontOfShop, "StockInGodownImage": Upload.godownStock,  "AdjoiningShopsImage": Upload.adjoiningShop,  "AttachData": Upload.other,  "AttachType":"jpg", "LeadType": Lead.leadType, "Remarks":Company.remarks] 

        SVProgressHUD.show()
//        print(parameters)
        addLead(url: leadDataURL, parameter: parameters)
        }else{
            SVProgressHUD.showInfo(withStatus: "Please upload the Visiting Card first")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(btn)
    }
    
    
    
    func addLead(url: String , parameter: [String:Any]){
        
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
           
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Request data")
                
//                print(loginJSON)
                if (loginJSON["returnType"].string?.contains("Lead Generated Successfully"))!{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    SVProgressHUD.dismiss(withDelay: 3)
//                    form.removeAll()
                    self.navigationController?.popViewController(animated: true)
                    
                }else {
                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                    SVProgressHUD.showError(withStatus: loginJSON["Message"].string)
                    SVProgressHUD.dismiss(withDelay: 3)
                }
                
            }
                
            else{
               
                print(loginJSON)
          
            }
        }
        
    }
    
    
}

extension UploadNewLeadViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Upload")
    }
    
}

