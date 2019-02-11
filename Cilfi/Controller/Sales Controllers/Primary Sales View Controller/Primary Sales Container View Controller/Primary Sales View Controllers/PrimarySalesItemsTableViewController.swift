//
//  PrimarySalesItemsTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 19/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import Alamofire
import MGSwipeTableCell
import SVProgressHUD



class PrimarySaleCell : MGSwipeTableCell{
    
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var quantityTF: UITextField!
    
    @IBAction func quantityTF(_ sender: UITextField) {
        
        if quantityTF.text == ""{
            SVProgressHUD.showError(withStatus: "Quantity cant be empty.")
            SVProgressHUD.dismiss(withDelay: 3)
            quantityTF.becomeFirstResponder()
        }else{
            if quantityTF.text == "0"{
                SVProgressHUD.showError(withStatus: "Quantity must be more than 0.")
                SVProgressHUD.dismiss(withDelay: 3)
                quantityTF.becomeFirstResponder()
            }else{
                quantityTF.resignFirstResponder()
                quantityTF.isEnabled = false
                Group.quantity[PrimarySalesItemsTableViewController.index] = quantityTF.text!
                PrimarySalesItemsTableViewController.refresh = true
            }
            
            
            
        }
        
    }
    
}

class PrimarySalesItemsTableViewController: UITableViewController {

    var qty = 0
    var totalPr = 0.0
    var totaldiscount = 0.0
    static var index = 0
    static var refresh = false
    
    var sales = SalesPostDataModel()
    
    @IBOutlet weak var totalQty: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    @IBAction func unwindToPrimarySalesTable(segue:UIStoryboardSegue) {
       
       
        updateNavBarVals()
        tableView.reloadData()
        
    }
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
    
        var items = [Any]()
        
        let location = AddressAndItem.location
        let ba = AddressAndItem.billingAddress
        let ccode = AddressAndItem.billingcustomerCode
        let cname = AddressAndItem.billingcustomerName
        let remark = AddressAndItem.remarks
        var distoCode = ""
        var sa = ""
        let totalquantity = String(qty)
         let totalprice = String(totalPr)
        //    {"itemPost":[{"BillAddress":"ANAND TUBES,108 PRAKASH INDUSTRIAL \nESTATE,ARADHNA CINEMA G.T. ROAD \nSAHIBABAD,-,,SAHIBABAD,UTTAR \nPRADESH,, ","CustomerCode":"16A042","CustomerName":"ANAND TUBES","DespTo":"16A042","Discount":"0.0","GroupCode":"9202","ItemCode":"92020002","ItemName":"ABS BALL VALVE \n(PLASTIC) -¾ \nINCH ","Location":"On Phone","OrderPrice":"380.0","Quantity":"1.0","Remark":"hiii","ShipAddress":"","TotalPrice":"380","TotalQty":"1","UnitPrice":"380.0"}]}
        
        if Group.groupID.count != 0{
            
            for x in 1...Group.groupID.count{
                let discount = Group.itemDiscount[x-1]
                let gCode = Group.groupID[x-1]
                let iCode = Group.itemID[x-1]
                let iName = Group.itemName[x-1]
                
                guard let quant = Double(Group.quantity[x-1]) else {return}
                guard let mrp = Double(Group.itemMrp[x-1]) else {return}
                guard let dis = Double(Group.itemDiscount[x-1]) else {return}
                var orderPrice = 0.0
                if dis == 0{
                    orderPrice = quant*mrp
                }else{
                    orderPrice = (quant*mrp)*(dis/100)
                }
                
                let quantity = Group.quantity[x-1]
               
                
                let unitPrice = Group.itemMrp[x-1]
                
               
                
                if Group.sameAsAbove == true{
                    if Group.otherAddress == false{
                        distoCode = AddressAndItem.billingcustomerCode
                        sa = AddressAndItem.billingAddress
                    }
                    else if Group.otherAddress == true{
                            distoCode = AddressAndItem.billingcustomerCode
                            sa = AddressAndItem.shippingOtherAddress
                        }
                }else{
                    distoCode = AddressAndItem.shippingcustomerCode
                    sa = AddressAndItem.shippingAddress
                }
                
                let item = ["BillAddress":ba,"CustomerCode":ccode,"CustomerName":cname, "DespTo":distoCode,"Discount":discount,"GroupCode":gCode,"ItemCode":iCode,"ItemName":iName,"Location":location,"OrderPrice":String(orderPrice),"Quantity":quantity,"Remark":remark,"ShipAddress":sa,"TotalPrice":totalprice,"TotalQty":totalquantity,"UnitPrice":unitPrice]
                
                items.append(item)
                
            }
            
            sales.postSalesData(url: "\(LoginDetails.hostedIP)/sales/Order", item: items) { (returnType) in
                if returnType == "Order Placed Successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    clearGroupAndAddress()
                    self.navigationController?.popViewController(animated: true)
                    
                    }else {
                    
                    SVProgressHUD.showError(withStatus: returnType)
                    SVProgressHUD.dismiss(withDelay: 3)
                }
            }
            
            print(items)
            
        }else{
            SVProgressHUD.showError(withStatus: "Please select valid Items.")
            
        }
       
    
    
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        
       
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Group.groupName.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "psCell", for: indexPath) as! PrimarySaleCell
        
        let more = MGSwipeButton(title: " Edit",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            cell.quantityTF.isEnabled = true
            PrimarySalesItemsTableViewController.index = indexPath.row
            cell.quantityTF.becomeFirstResponder()
            
            self.refreshVals()
            return true
            
        }
        
        let reject = MGSwipeButton(title: "Delete",icon: nil, backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            Group.groupID.remove(at: indexPath.row)
            Group.groupName.remove(at: indexPath.row)
            Group.itemID.remove(at: indexPath.row)
            Group.itemName.remove(at: indexPath.row)
            Group.quantity.remove(at: indexPath.row)
            Group.itemMrp.remove(at: indexPath.row)
            Group.itemDiscount.remove(at: indexPath.row)
            
            self.updateNavBarVals()
            tableView.reloadData()
            
            
            return true
            
        }
        
        cell.leftButtons = [more]
        cell.rightButtons = [reject]
        
        more.titleLabel?.font = more.titleLabel?.font.withSize(10)
        reject.titleLabel?.font = reject.titleLabel?.font.withSize(10)
       
        more.centerIconOverText()
        reject.centerIconOverText()
       
        
        cell.groupLbl.text = Group.groupName[indexPath.row]
        cell.itemLbl.text = Group.itemName[indexPath.row]
        cell.quantityTF.text = Group.quantity[indexPath.row]
        
        return cell
    }
    
    func refreshVals(){
        DispatchQueue.main.async{
        if PrimarySalesItemsTableViewController.refresh == false{
            self.refreshVals()
        }else{
            self.updateNavBarVals()
            PrimarySalesItemsTableViewController.refresh = false
        }
        }
    }
    
    
    func updateNavBarVals(){
        qty = 0
        totalPr = 0.0
        totaldiscount = 0.0
        
        for x in Group.quantity{
            qty = qty + Int(x)!
        }
        
        if Group.quantity.count != 0{
        for x in 1...Group.quantity.count{
            
            let itemquantity = Group.quantity[x-1]
            let itemmrp = Group.itemMrp[x-1]
            let itemdiscount = Group.itemDiscount[x-1]
            
            guard let quantity = Double(itemquantity) else {return}
            guard let mrp = Double(itemmrp) else {return}
            guard let discount = Double(itemdiscount) else {return}
               
                
            if discount == 0 {
                totalPr = totalPr + (mrp*quantity)
            }else{
                let disc = (mrp*quantity)*(discount/100)
                let price = (mrp*quantity) - disc
                
                totalPr = totalPr + price
                totaldiscount = totaldiscount + disc
            }

            
           

        }
        }
        totalQty.text = String(qty)
        totalPrice.text = String(totalPr)
    }

}
