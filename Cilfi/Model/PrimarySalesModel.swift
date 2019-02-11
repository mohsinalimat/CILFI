//
//  PrimarySalesModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 19/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

struct Group{
    
    static var groupName = [String]()
    static var groupID = [String]()
    static var itemID = [String]()
    static var itemName = [String]()
    static var quantity = [String]()
    static var itemMrp = [String]()
    static var itemDiscount = [String]()
    
    static var sameAsAbove = true
    static var otherAddress = false
}

struct AddressAndItem{
    
    static var billingAddress = ""
    static var billingcustomerCode = ""
    static var billingcustomerName = ""
    
    static var shippingAddress = ""
    static var shippingcustomerCode = ""
    static var shippingcustomerName = ""
    
    static var remarks = ""
    static var despTo = ""
    static var discount = ""
    static var groupCode = ""
    static var itemCode = ""
    static var itemName = ""
    static var location = ""
    static var orderPrice = ""
    static var quantity = ""
    static var totalPrice = ""
    static var totalQty = ""
    static var unitPrice = ""
    static var shippingOtherAddress = ""
}



func clearGroupAndAddress(){
    Group.groupName = [String]()
    Group.itemName = [String]()
    Group.itemID = [String]()
    Group.groupID = [String]()
    Group.quantity = [String]()
    Group.itemMrp = [String]()
    Group.itemDiscount = [String]()
    
    Group.sameAsAbove = true
    Group.otherAddress = false
    
    AddressAndItem.billingAddress = ""
    AddressAndItem.billingcustomerCode = ""
    AddressAndItem.billingcustomerName = ""
    
    AddressAndItem.shippingAddress = ""
    AddressAndItem.shippingcustomerCode = ""
    AddressAndItem.shippingcustomerName = ""
    
    AddressAndItem.remarks = ""
    AddressAndItem.despTo = ""
    AddressAndItem.discount = ""
    AddressAndItem.groupCode = ""
    AddressAndItem.itemCode = ""
    AddressAndItem.itemName = ""
    AddressAndItem.location = ""
    AddressAndItem.orderPrice = ""
    AddressAndItem.quantity = ""
    AddressAndItem.remarks = ""
    AddressAndItem.totalPrice = ""
    AddressAndItem.totalQty = ""
    AddressAndItem.unitPrice = ""
    
    AddressAndItem.shippingOtherAddress = ""
    
}

class PrimarySalesModel{
    
    var groupName = [String]()
    var groupCode = [String]()
    
    var itemName = [String]()
    var itemCode = [String]()
    var itemMrp = [String]()
    var itemDiscount = [String]()
    
    func getGroupData(){
        
        groupName = [String]()
        groupCode = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/groupname", method: .get, headers : headers).responseJSON{
            response in
            
            
            let groupData = response.data!
            let groupJSON = response.result.value
            
            if response.result.isSuccess{
//                                                print("UserJSON: \(groupJSON)")
                do{
                    let group = try JSONDecoder().decode(GroupRoot.self, from: groupData)
                    
                    for x in group.groupData{
                        
                        if let name = x.name{
                            self.groupName.append(name)
                        }
                        if let code = x.code{
                            self.groupCode.append(code)
                        }
                        
                    }
                    
                    SVProgressHUD.dismiss()
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
        
    }
    
    
    func getItemData(groupName : String){
        
        itemName = [String]()
        itemCode = [String]()
        itemMrp = [String]()
        itemDiscount = [String]()
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "groupName": groupName]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/item", method: .get, headers : header).responseJSON{
            response in
            
            let itemData = response.data!
            let itemJSON = response.result.value
            
            if response.result.isSuccess{
                //                                print("UserJSON: \(userDetailJSON)")
                do{
                    let items = try JSONDecoder().decode(ItemRoot.self, from: itemData)
                    
                    for x in items.itemData{
                        
                        if let name = x.name{
                            self.itemName.append(name)
                        }
                        if let code = x.code{
                            self.itemCode.append(code)
                        }
                        
                        if let mrp = x.mrp{
                            self.itemMrp.append(mrp)
                        }
                        
                        if let discount = x.discount{
                            self.itemDiscount.append(discount)
                        }
                        
                    }
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
        
    }
    
    
    
   
    
    
}


    

