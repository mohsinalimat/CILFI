//
//  LeadModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ""2/""7/18.
//  Copyright © 2""18 Focus Infosoft. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct Lead{
    static var createByCode = ""
    static var createdByName = ""
    static var salesmanCode = ""
    static var leadStatus = ""
    static var visitDate = ""
    static var executiveName = ""
    static var srInfo = ""
    static var srName = ""
    static var ddFirm = ""
    static var address = ""
    static var city = ""
    static var state = ""
    static var country = ""
    static var pincode = ""
    static var website = ""
    static var contactPersonName = ""
    static var designation = ""
    static var mobileNo = ""
    static var emailID = ""
    static var contactPersonEmailID = ""
    static var nextFollowUpDate = ""
    static var nextFollowUpTime = ""
    static var leadID = ""
    static var leadType = ""
    static var lat = ""
    static var lng = ""
}


struct Product{
    static var products = ""
    static var otherDealership = ""
    
    //Trade References
    // 1
    static var firmname1 = ""
    static var personname1 = ""
    static var mobileno1 = ""
    // 2
    static var firmname2 = ""
    static var personname2 = ""
    static var mobileno2 = ""
    //3
    static var firmname3 = ""
    static var personname3 = ""
    static var mobileno3 = ""
    
    static var billingSoft = ""
    static var interestedProducts = ""
    static var salesCommitedMonthly = ""
    
}

struct Upload{
    static var visitinCard = ""
    
    static var frontOfShop = ""
    static var godownStock = ""
    static var adjoiningShop = ""
    static var other = ""
}

struct Company{
    
    static var pan = ""
    static var gstin = ""
    static var fType = ""
    static var yearsInBusiness = ""
    
    static var annualTurnover1 = ""
    static var annualTurnover2 = ""
    static var annualTurnover3 = ""
    
    static var shopArea = ""
    static var shopOwnership = ""
    static var godownArea = ""
    static var godownOwnerShip = ""
    
    static var remarks = ""
    static var currentaddress = currentAddress
    
    
}

func clearValues(){
    
    //Lead variables
    Lead.createByCode = ""
    Lead.createdByName = ""
    Lead.salesmanCode = ""
    Lead.leadStatus = ""
    Lead.visitDate = ""
    Lead.executiveName = ""
    Lead.srInfo = ""
    Lead.srName = ""
    Lead.ddFirm = ""
    Lead.address = ""
    Lead.city = ""
    Lead.state = ""
    Lead.country = ""
    Lead.pincode = ""
    Lead.website = ""
    Lead.contactPersonName = ""
    Lead.designation = ""
    Lead.mobileNo = ""
    Lead.emailID = ""
    Lead.nextFollowUpDate = ""
    Lead.nextFollowUpTime = ""
    Lead.lat = ""
    Lead.lng = ""
    Lead.leadID = ""
    Lead.leadType = ""
    
    //Product variables
    Product.products = ""
    Product.otherDealership = ""
    Product.firmname1 = ""
    Product.personname1 = ""
    Product.mobileno1 = ""
    Product.firmname2 = ""
    Product.personname2 = ""
    Product.mobileno2 = ""
    Product.firmname3 = ""
    Product.personname3 = ""
    Product.mobileno3 = ""
    Product.billingSoft = ""
    Product.interestedProducts = ""
    Product.salesCommitedMonthly = ""
    
    //Upload variables
    Upload.visitinCard = ""
    Upload.frontOfShop = ""
    Upload.godownStock = ""
    Upload.adjoiningShop = ""
    Upload.other = ""
    
    //Company variables
    Company.pan = ""
    Company.gstin = ""
    Company.fType = ""
    Company.yearsInBusiness = ""
    Company.annualTurnover1 = ""
    Company.annualTurnover2 = ""
    Company.annualTurnover3 = ""
    Company.shopArea = ""
    Company.shopOwnership = ""
    Company.godownArea = ""
    Company.godownOwnerShip = ""
    Company.currentaddress = currentAddress
    Company.remarks = ""
    
    
}



    
    

